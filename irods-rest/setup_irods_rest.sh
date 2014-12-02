#!/bin/bash

cd /home/admin/irods-rest
cat <<EOF > src/main/resources/jargon-beans.xml
<?xml version="1.0" encoding="UTF-8"?>
<beans:beans xmlns="http://www.springframework.org/schema/security"
	xmlns:beans="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:sec="http://www.springframework.org/schema/security" xmlns:util="http://www.springframework.org/schema/util"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.1.xsd
                        http://www.springframework.org/schema/security http://www.springframework.org/schema/security/spring-security-3.1.xsd http://www.springframework.org/schema/context 
	http://www.springframework.org/schema/context/spring-context-3.1.xsd http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util-3.1.xsd">

	<beans:bean id="irodsConnectionManager"
		class="org.irods.jargon.core.connection.IRODSSimpleProtocolManager"
		factory-method="instance" init-method="initialize" destroy-method="destroy" />

	<beans:bean id="irodsSession"
		class="org.irods.jargon.core.connection.IRODSSession" factory-method="instance">
		<beans:constructor-arg
			type="org.irods.jargon.core.connection.IRODSProtocolManager" ref="irodsConnectionManager" />
	</beans:bean>

	<beans:bean id="irodsAccessObjectFactory"
		class="org.irods.jargon.core.pub.IRODSAccessObjectFactoryImpl">
		<beans:constructor-arg ref="irodsSession" />
	</beans:bean>

	<beans:bean id="serviceFunctionFactory"
		class="org.irods.jargon.rest.commands.ServiceFunctionFactoryImpl">
		<beans:property name="irodsAccessObjectFactory" ref="irodsAccessObjectFactory" />
		<beans:property name="restConfiguration" ref="restConfiguration" />
	</beans:bean>

    <beans:bean id="restConfiguration" class="org.irods.jargon.rest.configuration.RestConfiguration">
        <beans:property name="irodsHost" value="$irodshost" />
        <beans:property name="irodsPort" value="1247" />
        <beans:property name="irodsZone" value="$irodszone" />
        <beans:property name="defaultStorageResource" value="$irodsresc" />
        <beans:property name="authType" value="PAM" /> <!--  STANDARD,PAM -->
        <beans:property name="allowCors" value="false" />
        <beans:property name="corsAllowCredentials" value="false" />
        <beans:property name="corsOrigins">
            <util:list id="myList" value-type="java.lang.String">
                <beans:value>*</beans:value>
            </util:list>
        </beans:property>
        <beans:property name="corsMethods">
            <util:list id="myList" value-type="java.lang.String">
                <beans:value>GET</beans:value>
                <beans:value>POST</beans:value>
                <beans:value>DELETE</beans:value>
                <beans:value>PUT</beans:value>
            </util:list>
        </beans:property>
    </beans:bean>
	<beans:bean id="springFilter" class="org.irods.jargon.rest.auth.BasicAuthFilter" />


</beans:beans>

EOF

mvn package -Dmaven.test.skip=true

sudo cp /home/admin/irods-rest/target/irods-rest-4.0.2.1-SNAPSHOT.war \
       /var/lib/tomcat6/webapps/irods-rest.war

/usr/bin/supervisord "-n"
