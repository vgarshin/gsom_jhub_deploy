# Initialization of database and credentials
airflow db init && airflow users create \
  --username airflow \
  --firstname ${JUPYTERHUB_USER} \
  --lastname ${HOSTNAME} \
  --role Admin \
  --email ${JUPYTERHUB_USER}@gsom.spbu.ru \
  --password airflow 

# Start Airflow server
airflow webserver &>/dev/null & disown;

# Start scheduler
airflow scheduler &>/dev/null & disown;
