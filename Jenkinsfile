node {
    checkout(scm) 
    scmVars = checkout(scm)
    // echo "scmVars.BRANCH_NAME: ${scmVars.GIT_BRANCH.substring(7)}"
    // BRANCH_NAME = "${scmVars.GIT_BRANCH.substring(7)}"
    loadEnvironmentVariables("parameters/NONPROD.properties")  
    withCredentials([usernamePassword(credentialsId: 'vault', passwordVariable: 'VAULT_PASSWORD', usernameVariable: 'VAULT_USER')]) {
  
        stage ('CF Templates Build'){
            sh 'ansible-playbook site.yml -e "env=$BRANCH_NAME" --tags "prepare"'
        }

        stage ('CF Templates Validation'){
            sh 'ansible-playbook site.yml -e "env=$BRANCH_NAME"  --tags "validate"'
        }

        stage ('CF Templates Deployment'){
            sh 'ansible-playbook site.yml -e "env=$BRANCH_NAME"  --tags "deploy"'
        }

        stage ('Instance Validation'){
            sh 'python scripts/update_hosts.py --extra-vars "@vaults/secret.yml"'
            sh 'chmod +x scripts/vault.py'
        }

        stage ('Meduawiki Installation'){
            //  sh 'ansible-playbook site.yml --vault-password-file scripts/vault.py --extra-vars "@vaults/secret.yml" -i hosts --tags=install-mediawiki'
            sh 'ansible-playbook site.yml --extra-vars "env=$BRANCH_NAME" --tags=install-mediawiki'
        }

    } 
}    

def loadEnvironmentVariables(path){ 
    def props = readProperties  file: path
    keys= props.keySet()
    for(key in keys) {
        value = props["${key}"]
    }
}