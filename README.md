# ELK-Stack-Project-IMC
The files in this repository were used to configure the network depicted below.
​
**Note**: The following image link needs to be updated. Replace `diagram_filename.png` with the name of your diagram image file.  
​
![TODO: Update the path with the name of your diagram](Images/diagram_filename.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the YAML file may be used to install only certain pieces of it, such as Filebeat and MetricBeat.

​https://github.com/ICohen06/ELK-Stack-Project-IMC/blob/main/Ansible/install-elk.yml

​https://github.com/ICohen06/ELK-Stack-Project-IMC/blob/main/Ansible/filebeat-config.yml

​https://github.com/ICohen06/ELK-Stack-Project-IMC/blob/main/Ansible/filebeat-playbook.yml

​https://github.com/ICohen06/ELK-Stack-Project-IMC/blob/main/Ansible/metricbeat-config.yml

​https://github.com/ICohen06/ELK-Stack-Project-IMC/blob/main/Ansible/metricbeat-playbook.yml


This document contains the following details:
- Description of the Topologu
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build
​

### Description of the Topology
​
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.
​

Load balancing ensures that the application will be highly available, in addition to restricting inbound to the network.

  What aspect of security do load balancers protect? 

According to Azure security baseline for Azure Load Balancer, the load balancer's main purpose is to distribute web traffic across multiple servers. In our network, the load balancer was installed in front of the VM to
  
    ​protect Azure resources within virtual networks.
  
    ​monitor and log the configuration and traffic of virtual networks, subnets, and NICs.
  
    ​protect crticial web applications
  
    ​deny communications with known malicious IP addresses
  
    ​record network packets
  
    ​deploy network-based intrusion detection/intrusion prevention systems (IDS/IPS)
  
    ​manage traffic to web applications
   
    ​minimize complexity and administrative overhead of network security rules
  
    ​maintain standard security configurations for network devices
  
    ​document traffic configuration rules
  
    ​use automated tools to monitor network resource configurations and detect changes

What is the advantage of a jump box?


  ​A Jump Box or a "Jump Server" is a gateway on a network used to access and manage devices in different security zones. A Jump Box acts as a "bridge" between two       trusted networks zones and provides a controlled way to access them. We can block the public IP address associated with the VM. It helps to improve security also       prevents all Azure VM’s to expose to the public.
  
  
  Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to their file systems and system metrics such as priviledge escalation         failure, SSH logins activity, CPU and memory usage, etc.
  
  
What does Filebeat watch for?

  Filebeat helps keep things simple by offering a lightweight way (low memory footprint) to forward and centralize logs, files and watches for changes.
  

What does Metricbeat record?

​Filebeat helps keep things simple by offering a lightweight way (low memory footprint) to forward and centralize logs, files and watches for changes.

The configuration details of each machine may be found below.

|        **Name**        	|  **Function** 	|       **IP Address**       	| **Operating System** 	|
|:----------------------:	|:-------------:	|:--------------------------:	|----------------------	|
| _Jump-Box-Provisioner_ 	|    Gateway    	| 20.212.233.163<br>10.1.0.4 	|         Linux        	|
|         _Web-1_        	|   webserver   	|          10.1.0.5          	|         Linux        	|
|         _Web-2_        	|   webserver   	|          10.1.0.6          	|         Linux        	|
|       _ElkServer_      	|     Kibana    	|          10.4.0.4          	|         Linux        	|
|     _BlackTeam-LB_     	| Load Balancer 	|        20.211.75.214       	|         DVWA         	|

In addition to the above, Azure has provisioned a load balancer in front of all machines except for the jump box. The load balancer's targets are organized into availability zones: Web-1 + Web-2
​
### Access Policies
​
The machines on the internal network are not exposed to the public Internet. 
​
Only the Jump Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses: 20.211.75.214
​
Machines within the network can only be accessed by SSH from Jump Box.
​
A summary of the access policies in place can be found in the table below.
​
| Name                	| Publicly Accessible 	| Allowed IP Addresses 	|
|---------------------	|---------------------	|----------------------	|
| Jump-Box Provsioner 	|         Yes         	|     20.211.75.214    	|
|      ElkServer      	|         Yes         	|  20.211.75.214:5601  	|
|        DVWA1        	|          No         	|      10.1.0.1-254    	|
|        DVWA2        	|          No         	|     10.1.0.1-254     	|
​
### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because Ansible can be used to easily     configure new machines, update programs, and configurations on hundreds of servers at once, and the best part is that the process is the same whether we're managing    one machine or dozens and even hundreds.

What is the main advantage of automating configuration with Ansible?

​ Ansible is focusing on bringing a server to a certain state of operation.

We will configure an ELK server within virtual network. Specifically,

  Deployed a new VM on our virtual network.
  Created an Ansible play to install and configure an ELK instance.
  Restricted access to the new server.
  
  
 Deployed a new VM on our virtual network.
  1. Create a new vNet located in the same resource group we have been using.
  Make sure this vNet is located in a new region and not the same region as our other VM's, which region we select is not important as long as it's a different US       region than our other resources, we can also leave the rest of the settings at default.
  In this example, that the IP Addressing has automatically created a new network space of 10.4.0.4/16. If our network is different (10.1.0.5 or 10.1.0.6) it is ok       as long as we accept the default settings. Azure automatically creates a network that will work.
  
 ![image](https://user-images.githubusercontent.com/106039539/170564248-be2f3632-f580-4abc-840d-6b918bf52845.png)



2. Create a Peer connection between our vNets. This will allow traffic to pass between our vNets and regions. This peer connection will make both a connection from our  first vNet to our second vNet and a reverse connection from our second vNet back to our first vNet. This will allow traffic to pass in both directions.
  Navigate to Virtual Network in the Azure Portal.
  Select our new vNet to view it's details.
  Under Settings on the left side, select Peerings.
  Click the + Add button to create a new Peering.
  A unique name of the connection from our new vNet to our old vNet such as depicted example below.
  Choose our original RedTeam vNet in the dropdown labeled Virtual Network.
  Leave all other settings at their defaults.

![image](https://user-images.githubusercontent.com/106039539/170533672-cdd78677-87b1-4758-afde-f0712873122e.png)
![image](https://user-images.githubusercontent.com/106039539/170534373-0f4fc583-187a-4231-b4cc-ebd615f0899d.png)




 Create a new Ubuntu VM in our virtual network with the following configurations:
The VM must have a public IP address.

The VM must be added to the new region in which we created our new vNet. We want to make sure we select our new vNEt and allow a new basic Security Group to be created for this VM.

The VM must use the same SSH keys as our WebserverVM's. This should be the ssh keys that were created on the Ansible container that's running on our jump box.

After creating the new VM in Azure, verify that it works as expected by connecting via SSH from the Ansible container on our jump box VM.

![image](https://user-images.githubusercontent.com/106039539/170531439-f19738ea-a903-4f77-8b2f-d381618ab50e.png)

Copy the SSH key from the Ansible container on our jump box:
  RUN cat id_rsa.pub Configure a new VM using that SSH key:
  
![image](https://user-images.githubusercontent.com/106039539/170565306-b69f5719-4fcd-49e3-9c01-34a48075c6b7.png)

Created an Ansible play to install and configure an ELK instance.
In this step, we have to:

Add new VM to the Ansible hosts file.
Create a new Ansible playbook to use for our new ELK virtual machine.
From our Ansible container, add the new VM to Ansible's hosts file.
  RUN nano /etc/ansible/hosts and put our IP with ansible_python_interpreter=/usr/bin/python3

The playbook implements the following tasks:
- 
- ...
- ...
​
The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

​
**Note**: The following image link needs to be updated. Replace `docker_ps_output.png` with the name of your screenshot image file.  
​
​
![TODO: Update the path with the name of your screenshot of docker ps output](Images/docker_ps_output.png)
​
### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- _TODO: List the IP addresses of the machines you are monitoring_
​
We have installed the following Beats on these machines:
- _TODO: Specify which Beats you successfully installed_
​
These Beats allow us to collect the following information from each machine:
- _TODO: In 1-2 sentences, explain what kind of data each beat collects, and provide 1 example of what you expect to see. E.g., `Winlogbeat` collects Windows logs, which we use to track user logon events, etc._
​
### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 
​
SSH into the control node and follow the steps below:
- Copy the _____ file to _____.
- Update the _____ file to include...
- Run the playbook, and navigate to ____ to check that the installation worked as expected.
​
_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it?_
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- _Which URL do you navigate to in order to check that the ELK server is running?
​
_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._
