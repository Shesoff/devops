# Собираем из базового jdk8 версии
FROM jboss/base-jdk:8

# Устанавливаем WILDFLY_VERSION переменную окружения
ENV WILDFLY_VERSION 18.0.1.Final
ENV WILDFLY_SHA1 ef0372589a0f08c36b15360fe7291721a7e3f7d9
ENV JBOSS_HOME /opt/jboss/wildfly

USER root

# Распаковываем WildFly в диру /opt, делаем позователя jboss владельцем
# Создаем пользователя в адмику WildFly
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm -f wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME} \
    && $JBOSS_HOME/bin/add-user.sh wildfly wildfly --silent

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Прослушиваемые порты
EXPOSE 8080
EXPOSE 9990

# Копируем наше приложение в контейнер
ADD *.war /opt/jboss/wildfly/standalone/deployments/

# Запускаем WildFly в standalone режиме и биндимся на любой интерфеейс
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
