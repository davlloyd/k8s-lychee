"""
Lychee Application Wavefront Telegraf Configuration Tool

Written for Python 3.5+
Assumes PKS cli command tools are in path

"""

import json, os, base64, subprocess
from kubernetes import client, config

pksapi = 'pks-api.syddsc.local'
pksuser = 'david'
pkspassword = 'password'
applabel = 'lychee'
webtier = 'frontend'
dbtier = 'mysql'
clusters = []
pods = []
telegrafConfig = '/Users/lloydd/Documents/playpen/telegraf.d/'


def setPKSLogin():
    """ Login into PKS """
    p = subprocess.Popen(['pks', 'login', '-a', pksapi, '-u', pksuser, '-p', pkspassword, '-k'], 
        stdout=subprocess.PIPE, shell=False, stderr=subprocess.DEVNULL)
    (output) = p.communicate()

    if (p.wait() == 0):    
        return True
    else:
        print ("Error: %s", output)
        return False


def getClusterList():
    """ Get a list of Kubernetes clusters from PKS """

    p = subprocess.Popen(['pks', 'clusters', '--json'], stdout=subprocess.PIPE)
    (output, err) = p.communicate()
    if (p.wait() == 0):
        l = json.loads(output)
        for item in l: 
            clusters.append(item['name'])
        return True
    else:
        print ("Error: %s", output)
        return False

def setClusterConfig(clusterName):
    """ Set kube config to supplied cluster """

    p = subprocess.Popen(['pks', 'get-credentials', clusterName], 
        stdout=subprocess.PIPE, shell=False, stderr=subprocess.DEVNULL)
    (output) = p.communicate()

    if (p.wait() == 0):    
        return True
    else:
        print ("Error: %s", output)
        return False

def getPodList(cluster):
    """ Get the list of Pods with matching labels and check if config exists """

    config.load_kube_config()
    v1 = client.CoreV1Api()
    filter = "app={}".format(applabel)
    ret = v1.list_pod_for_all_namespaces(watch=False, label_selector=filter)

    for i in ret.items:
        pod_id = i.metadata.name[-5:]
        pods.append(pod_id)

        if(i.metadata.labels['tier'] == "frontend"):
            filename = "{}nginx-{}.conf".format(telegrafConfig, pod_id)
            if(not os.path.isfile(filename)):
                createNginxDef(cluster, i.metadata.namespace, filename, i.status.pod_ip)
        else:
            filename = "{}mysql-{}.conf".format(telegrafConfig, pod_id)
            if(not os.path.isfile(filename)):
                for envVar in i.spec.containers[0].env:
                    if (envVar.name == "MYSQL_ROOT_PASSWORD"):
                        secret = v1.read_namespaced_secret(envVar.value_from.secret_key_ref.name, i.metadata.namespace)
                        password = base64.b64decode(secret.data['password']).decode('ascii')
                        createMySqlDef(cluster, i.metadata.namespace, filename, i.status.pod_ip, password)

def deleteRemovedPodConf():    
    """ Delete conf files for pods that no longer exist """
    for f in os.listdir(telegrafConfig):
        if("mysql" in f or "nginx" in f):
            if not f[6:-5] in pods:
                os.remove("{}{}".format(telegrafConfig, f))


def createNginxDef(cluster, namespace, filename, ipAddress):
    """ Create MySql config file for telegraf """
    f= open(filename,"w+")
    f.write('[[inputs.nginx]]\n')
    f.write('  urls = ["http://{}/basic_status"]\n'.format(ipAddress))
    f.write('[inputs.nginx.tags]\n')
    f.write('  app = "{}"\n'.format(applabel))
    f.write('  cluster = "{}"\n'.format(cluster))
    f.write('  namespace = "{}"\n'.format(namespace))
    f.close()


def createMySqlDef(cluster, namespace, filename, ipAddress, password):
    """ Create MySql config file for telegraf """
    f= open(filename,"w+")
    f.write('[[inputs.mysql]]\n')
    f.write('  servers = ["root:{}@tcp({}:3306)/?tls=false"]\n'.format(password, ipAddress))
    f.write('  perf_events_statements_digest_text_limit = 120\n')
    f.write('  perf_events_statements_limit = 250\n')
    f.write('  perf_events_statements_time_limit = 86400\n')   
    f.write('  table_schema_databases = []\n')
    f.write('  gather_table_schema = false\n')
    f.write('  gather_process_list = true\n')
    f.write('  gather_user_statistics = true\n')
    f.write('  gather_info_schema_auto_inc = true\n')
    f.write('  gather_innodb_metrics = true\n')
    f.write('  gather_slave_status = true\n')
    f.write('  gather_binary_logs = false\n')
    f.write('  gather_table_io_waits = false\n')
    f.write('  gather_table_lock_waits = false\n')
    f.write('  gather_index_io_waits = false\n')
    f.write('  gather_event_waits = false\n')
    f.write('  gather_file_events_stats = false\n')
    f.write('  gather_perf_events_statements = false\n')
    f.write('  interval_slow = "30m"\n')
    f.write('[inputs.mysql.tags]\n')
    f.write('  app = "{}"\n'.format(applabel))
    f.write('  cluster = "{}"\n'.format(cluster))
    f.write('  namespace = "{}"\n'.format(namespace))
    f.close()



if(os.path.isdir(telegrafConfig)):
    if (setPKSLogin()):
        getClusterList()
        for cluster in clusters:
            setClusterConfig(cluster)
            getPodList(cluster)
        deleteRemovedPodConf()
else:
    print("Error: Supplied Telegraf config path '{}' does not exist".format(telegrafConfig))
    

