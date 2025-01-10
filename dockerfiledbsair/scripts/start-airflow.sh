# Initialization of database and credentials
airflow db migrate && airflow users create \
  --username airflow \
  --firstname ${JUPYTERHUB_USER} \
  --lastname ${HOSTNAME} \
  --role Admin \
  --email ${JUPYTERHUB_USER}@gsom.spbu.ru \
  --password airflow 

# Start Airflow server
rm /home/${NB_USER}/airflow/*.pid && \
  airflow webserver &>/dev/null & disown;

# Start scheduler
airflow scheduler &>/dev/null & disown;