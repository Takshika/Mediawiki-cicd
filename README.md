## General Info
This pipeline is used to install Mediawiki application via a CICD pipeline.  

## Used Skills
* Ansible
* CICD 
* CF Templates
* GitHub
* Jenkins
## Setup
Jenkinsfile is called in jenkins console which holds the references to all the underlying code files.
On Jenkins server make sure ansible, boto3, awscli, botocore is prsent. Also make sure the SG on the Jenkins server has all the necessary ports enable like  port 22,443,80. Make sure the IAM roles has sufficient permission to deploy the cloudformation template and access S3. 
 
Once the Jenkins server has all preconfiguration setup, provide the bucket name in group_vars all.yml file and build the pipeline from jenkins console. 

## Working of the pipeline
Jenkinsfile  (ie different stages define within Jenkinsfile) works as the base or reference file to refer to whole structure of the CICD pipeline.

Accoding to the setup here, once we build the do a Build on Jenkins console, it would go and fetch the latest code from Github. And pickups the variables at the runtime define under properties folder. (The reference is happening because of the function define in the Jenkinsfile).

The required credetials to login to the instance at the run time is kept under vault credentials. Create this file(Say secret.yml) On jenkins server and keep all the secerts stored inside this in key-value format( command to create secret.yml file is: ansible-vault create secret.yml). This file can be decrypted with the vault password provided at the runtime with "withCredentials" parameter supported by jenkinsfile. Makesure to add vault username and password on jenkins console credentials tab.

Further the stages start getting executing step by step, Starting from Stage Build Environment. This stage refers to the file site.yml and refer to the task with tag "prepare". On site.yml file it refers to the role prepare-cf-template and execute the tasks provided in the main.yml file(or the subsequent file). Once all the action under this role has been executed, then it goes back to Jenkinsfile second stage ie Validate CF Template, followed by Third stage and proceed with similar approach, going from site.yml file wrt to tag and execute the action define under that role.

The idea of the CICD pipeline is to first keep the Cf template in S3 bucket, then deploy it with cloudformation application. The secrets in encrypted format is also kept in S3 which decrypts further only at runtime with proper vault credentials provided. Once the CF template code gets deploy and our resources are created, boto3 code has been used to fetch the private ip address of the recently launched instance and save this ip in hosts file at run time. Post which with vault credentials the instance would be login and all the steps provided in install-mediawiki and validate-wiki will get executed.
## Different file use case:
* Jenkinsfile( written in Groovy format):This file contains different stages like build environment, Validating CF template, Deploying CF template , Installation and Validation of the Mediawiki.
* Site.yml: Jenkinsfile calls site.yml file which corresponds to individual roles like prepare cf template, validate cf template ,deploy cf template, deploy mediawiki and validate mediawiki.
* Inventory: Defines the inventory for the script. 
* ansible.cfg: It holds the ansible configuration. 
* .gitignore: use to exclude files with particular extension while running the code.
* groupvars: holds the common variable required in script.
* roles: site.yml file calls indiviual roles(main.yml file corresponding to each role) with respect to its defined tags.
* cf_templates: Hold the code written in Cloud formation format. 

## Usage
To deploy Mediawiki with CICD pipeline, thereby reducing the manual efforts and  have a better tracking in future.
