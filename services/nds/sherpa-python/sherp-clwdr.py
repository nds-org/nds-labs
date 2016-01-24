#!/usr/bin/python

from flask import Flask
from flask.ext import restful
from flask_restful import reqparse, abort, Api, Resource
#from subprocess import call
import os

app = Flask(__name__)
api = restful.Api(app)

parser = reqparse.RequestParser()
parser.add_argument('dataset')
parser.add_argument('user')
parser.add_argument('pw')
parser.add_argument('host')

class IpyClowder(restful.Resource):
    def get(self):
        return {'hello': 'world'}

    def post(self):
        args = parser.parse_args()
	cmd = '/usr/bin/docker create -v /nds/data pysherpactl wget --user=' + str(args['user']) + ":"+str(args['pw'])+ " "+ str(args['dataset'])+ " -P /nds/data"
	print cmd
	dataContainer = os.popen(cmd).read().rstrip()
	print "DC: ", dataContainer
        startOut = os.popen("docker start "+dataContainer).read().rstrip()
	print "SO: " + startOut
	toolCmd = "/usr/bin/docker run -P -d --volumes-from " + startOut + " jupyter/scipy-notebook"
	print "TC: ", toolCmd
	toolContainer = os.popen(toolCmd).read().rstrip()
	portcmd = "/usr/bin/docker inspect --format '{{(index (index .NetworkSettings.Ports \"8888/tcp\") 0).HostPort}}' " + toolContainer
	print "PCMD:", portcmd
	port = os.popen(portcmd).read().rstrip()
	print 'on port ' + port
	ret = {}
	ret['id'] = "/tools/docker/"+str(id)
	ret['URL'] = args['host']+":"+port 
	print ret
	return ret, 201

api.add_resource(IpyClowder, '/tools/docker/ipython')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=int("8080"), debug=True)
