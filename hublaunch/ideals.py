import stat
import os
import pprint
import datetime
import fs
import fs.base
import fs.zipfs
import fs.mountfs
import fnmatch
import thingking
from oaipmh.client import Client
from oaipmh.metadata import MetadataRegistry, oai_dc_reader, MetadataReader
from fs.expose import fuse

# Example:
#
# <atom:entry xmlns:atom="http://www.w3.org/2005/Atom" xmlns:doc="http://www.lyncode.com/xoai" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:oreatom="http://www.openarchives.org/ore/atom/" xmlns:ore="http://www.openarchives.org/ore/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.openarchives.org/OAI/2.0/" xsi:schemaLocation="http://www.w3.org/2005/Atom http://www.kbcafe.com/rss/atom.xsd.xml">
# <atom:id>http://hdl.handle.net/2142/14/ore.xml</atom:id>
# <atom:link rel="alternate" href="http://hdl.handle.net/2142/14"/>
# <atom:link rel="http://www.openarchives.org/ore/terms/describes" href="http://hdl.handle.net/2142/14/ore.xml"/>
# <atom:link type="application/atom+xml" rel="self" href="http://hdl.handle.net/2142/14/ore.xml#atom"/>
# <atom:published>2006-07-21T20:33:04Z</atom:published>
# <atom:updated>2006-07-21T20:33:04Z</atom:updated>
# <atom:source>
# <atom:generator>IDEALS @ Illinois</atom:generator>
# </atom:source>
# <atom:title>Theater missile defense and the Anti-Ballistic Missile (ABM) Treaty : either-or?</atom:title>
# <atom:category label="Aggregation" term="http://www.openarchives.org/ore/terms/Aggregation" scheme="http://www.openarchives.org/ore/terms/"/>
# <atom:category scheme="http://www.openarchives.org/ore/atom/modified" term="2006-07-21T20:33:04Z"/>
# <atom:category label="DSpace Item" term="DSpaceItem" scheme="http://www.dspace.org/objectModel/"/>
# <atom:link rel="http://www.openarchives.org/ore/terms/aggregates" href="https://www.ideals.illinois.edu/bitstream/2142/14/1/Theater_Missile_Defense.pdf" title="Theater_Missile_Defense.pdf" type="application/pdf" length="695969"/>
# <oreatom:triples>
# <rdf:Description xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" rdf:about="http://hdl.handle.net/2142/14/ore.xml#atom">
# <rdf:type rdf:resource="http://www.dspace.org/objectModel/DSpaceItem"/>
# <dcterms:modified>2006-07-21T20:33:04Z</dcterms:modified>
# </rdf:Description>
# <rdf:Description xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" rdf:about="https://www.ideals.illinois.edu/bitstream/2142/14/1/Theater_Missile_Defense.pdf">
# <rdf:type rdf:resource="http://www.dspace.org/objectModel/DSpaceBitstream"/>
# <dcterms:description>ORIGINAL</dcterms:description>
# </rdf:Description>
# <rdf:Description xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" rdf:about="https://www.ideals.illinois.edu/bitstream/2142/14/2/license.txt">
# <rdf:type rdf:resource="http://www.dspace.org/objectModel/DSpaceBitstream"/>
# <dcterms:description>LICENSE</dcterms:description>
# </rdf:Description>
# <rdf:Description xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" rdf:about="https://www.ideals.illinois.edu/bitstream/2142/14/3/Theater_Missile_Defense.pdf.txt">
# <rdf:type rdf:resource="http://www.dspace.org/objectModel/DSpaceBitstream"/>
# <dcterms:description>TEXT</dcterms:description>
# </rdf:Description>
# </oreatom:triples>
# </atom:entry>

ore_reader = MetadataReader(
    fields={
        'handle':    ('textList', 'atom:entry/atom:link[@rel=\'alternate\']/@href'),
        'title':     ('textList', 'atom:entry/atom:title/text()'),
        'published': ('textList', 'atom:entry/atom:published/text()'),
        'updated':   ('textList', 'atom:entry/atom:updated/text()'),
        # Only "ORIGINAL" documents
        'links':     ('textList', 'atom:entry/oreatom:triples/rdf:Description/dcterms:description[node()=\'ORIGINAL\']/../@rdf:about'),
    },
    namespaces={
     'atom':        'http://www.w3.org/2005/Atom',
     'dc':          'http://purl.org/dc/elements/1.1/',
     'dcterms':     'http://purl.org/dc/terms/',
     'dcmitype':    'http://purl.org/dc/dcmitype/',
     'foaf':        'http://xmlns.com/foaf/0.1/',
     'owl':         'http://www.w3.org/2002/07/owl',
     'ore':         'http://www.openarchives.org/ore/terms/',
     'oreatom':     'http://www.openarchives.org/ore/atom/',
     'rdf':         'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
     'rdfg':        'http://www.w3.org/2004/03/trix/rdfg-1/',
     'rdfs':        'http://www.w3.org/2000/01/rdf-schema',

    }
)

URL = 'http://www.ideals.illinois.edu/dspace-oai/request'
registry = MetadataRegistry()
registry.registerReader('ore', ore_reader)
client = Client(URL, registry)
#for i, record in enumerate(client.listRecords(metadataPrefix='ore')):
#    pprint.pprint(record[1].getMap())
#    if i >= 100: break

TRACE_DEBUG = False
#TRACE_DEBUG = True

def trace(func):
    if not TRACE_DEBUG: return func
    def _trace(*args, **kwargs):
        print "Entering", func.func_name, args, kwargs
        rv = func(*args, **kwargs)
        print "Exiting", func.func_name, rv
        return rv
    return _trace

def _fix_path(path):
    path = fs.path.normpath(path)
    if path =='' or path[0] != "/":
        path = "/" + path
    return path

def _fix_name(name):
    return name.replace("/", "_")

class IDEALSFilesystem(fs.base.FS):
    _meta = {'thread_safe': False,
             'virtual': False,
             'read_only': True,
             'unicode_paths': True,
             'case_insensitive_paths': False,
             'network': True,
             }

    def __init__(self, base_fs, thread_synchronize=True):
        super(IDEALSFilesystem, self).__init__(thread_synchronize=thread_synchronize)
        self.base_fs = base_fs
        # Now set up our ideals client
        self._URL = 'http://www.ideals.illinois.edu/dspace-oai/request'
        self._registry = MetadataRegistry()
        self._registry.registerReader('ore', ore_reader)
        self._client = Client(URL, registry)
        self._coll_map = fs.path.PathMap()
        self._coll_info = {}
        self._mounted_zips = fs.path.PathMap()
        for i, (k, v, _) in enumerate(self._client.listSets()):
            v = _fix_name(v)
            self._coll_map[fs.path.normpath(v)] = k

    def _get_collection(self, coll_id):
        if coll_id in self._coll_info:
            return self._coll_info[coll_id]
        records = self._client.listRecords(
                metadataPrefix='ore',
                set=coll_id)
        rmap = [record[1].getMap() for record in records]
        self._coll_info[coll_id] = dict(((_fix_name(r["title"][0]), r)
                                          for r in rmap))
        return self._coll_info[coll_id]

    @trace
    def open(self, path, mode='r', buffering=-1, encoding=None, errors=None,
            newline=None, line_buffering=False, **kwargs):
        path = _fix_path(path)
        if 'r' not in mode:
            raise fs.errors.UnsupportedError(opname='readwrite', path=path)
        if not self.isfile(path):
            raise fs.errors.ResourceNotFoundError(path)
        # Now we get our file URL
        url = self._get_url(path)
        f = thingking.httpfile(url)
        return f

    def _get_url(self, path):
        _, coll, rec, fn = path.split("/")
        rec = self._get_collection(self._coll_map[coll])[rec]
        links = rec["links"]
        url = None
        for link in links:
            if os.path.basename(link) == fn:
                assert(url is None)
                url = link
        return url

    @trace
    def isfile(self, path, consider_zip_files = False):
        path = _fix_path(path)
        if path == "/":
            return False
        d, f = fs.path.pathsplit(path)
        # Now how many levels deep are we
        if d == "/":
            return False
        if d.count("/") == 2: # We are inside a collection and record
            coll, rec = fs.path.pathsplit(d)
            if coll not in self._coll_map: return False
            records = self._get_collection(self._coll_map[coll])
            if rec not in records: return False
            rec = records[rec]
            exists = any(fs.path.basename(l) == f for l in rec["links"])
            return exists
        return False

    @trace
    def isdir(self, path):
        path = _fix_path(path)
        if path == "/" or path == '':
            return True
        if path.count("/") > 2:
            if path.endswith(".zip_dir") and self.isfile(path[:-4]):
                return True
            elif not self.isfile(path, True):
                return True
            return False
        elif path.count("/") == 2:
            coll, rec = fs.path.pathsplit(path)
            records = self._get_collection(self._coll_map[coll])
            return rec in records
        elif path.count("/") == 1:
            _, coll = fs.path.pathsplit(path)
            return coll in self._coll_map

    @trace
    def listdir(self, path='./', wildcard=None, full=False, absolute=False,
            dirs_only=False, files_only=False):
        # We want to split the path and then get the collection
        path = _fix_path(path)
        if path == "/" or path == '':
            # Get our list of collections
            if files_only: return []
            if wildcard is not None:
                return [v[1:] for v in self._coll_map.keys()
                        if fnmatch.fnmatch(v, wildcard)]
            return [v[1:] for v in self._coll_map.keys()]
        # We're just going to get files at this point
        elif path.count("/") == 2:
            # Inside a record now
            coll, rec = fs.path.pathsplit(path)
            coll = self._get_collection(self._coll_map[coll])
            if rec not in coll:
                raise fs.errors.ResourceNotFoundError(path)
            rv = [fs.path.basename(l) for l in coll[rec]["links"]]
        elif path.count("/") == 1:
            # At top level
            coll = self._get_collection(self._coll_map[path])
            rv = [_fix_name(r["title"][0]) for r in coll.values()]
        else:
            raise fs.errors.ResourceNotFoundError(path)
        if wildcard is not None:
            rv = [v for v in rv if fnmatch.fnmatch(v, wildcard)]
        for v in rv[:]:
            if v.endswith(".zip"):
                rv.append(v + "_dir")
                p = os.path.join(path, rv[-1])
                if p not in self._mounted_zips:
                    f = thingking.httpfile(self._get_url(fs.path.join(path, v)))
                    zfs = fs.zipfs.ZipFS(f)
                    self._mounted_zips[p] = zfs
                    self.base_fs.mountdir(p, zfs)
        print "RV", len(rv)
        return rv

    @trace
    def makedir(self, path, recursive=False, allow_recreate=False):
        raise fs.errors.UnsupportedError(opname='makedir', path=path)

    @trace
    def remove(self, path):
        raise fs.errors.UnsupportedError(opname='remove', path=path)

    @trace
    def removedir(self, path, recurseive=False, force=False):
        raise fs.errors.UnsupportedError(opname='removedir', path=path)

    @trace
    def rename(self, src, dst):
        raise fs.errors.UnsupportedError(opname='rename', path=src)

    @trace
    def getinfo(self, path):
        path = _fix_path(path)
        if not self.isfile(path) and not self.isdir(path):
            raise fs.errors.ResourceNotFoundError(path)

        info = {}
        info['created_time'] = datetime.datetime.now()
        info['modified_time'] = datetime.datetime.now()
        info['accessed_time'] = datetime.datetime.now()

        if self.isdir(path) or path in self._mounted_zips:
            info['size'] = 10
            info['st_mode'] = 0755 | stat.S_IFDIR
        else:
            url = self._get_url(path)
            f = thingking.httpfile(url)
            info['size'] = f.size
            info['st_mode'] = 0666 | stat.S_IFREG

        return info

#base_fs = fs.mountfs.MountFS()
#ifs = IDEALSFilesystem(base_fs)
#files1 = ifs.listdir("/")
#files2 = ifs.listdir(files1[5])
#files3 = ifs.listdir(files1[5] + "/" + files2[0])
#info = ifs.getinfo(os.path.join(files1[5], files2[0], files3[0]))
#base_fs.mountdir("", ifs)
#xl_fn = "/Connecting to Collections/Arizona Survey Raw Data/AZ+Raw+Data.xls"
#mp = fuse.mount(base_fs, "/home/mturk/ideals/", foreground=True)
