// This is a Jenkinsfile, when Jenkins is used, it searches a repository and executes files of this name

try {
  stage('checkout') {
    node {
      cleanWs()
      checkout scm
   }
  }


  // Run terraform init 
  stage('init') {
      node {
       withCredentials([[
      
  
      $class: 'VaultTokenCredentialBinding', 
   credentialsId: 'vault-github-access-token', 
   vaultAddr: 'http://VAULT_SERVER']]) 
         {    ansiColor('xterm') {
  
        // values will be masked
        sh 'echo TOKEN=$VAULT_TOKEN'
        sh 'echo ADDR=$VAULT_ADDR'
           sh 'terraform init' 
           
         }        
        }
       }                   
      }

 

  // Run terraform plan
  stage('plan ') {
    node {
       withCredentials([[
      
     $class: 'VaultTokenCredentialBinding', 
        // This token is the name of the GitHub Token you stored on Jenkins 
   credentialsId: 'vault-github-access-token', 
        // This is the name of the vault server that you launced  
   vaultAddr: 'http://VAULT_SERVER']]) 
         {    ansiColor('xterm') {
  
        // values will be masked
        sh 'echo TOKEN=$VAULT_TOKEN'
        sh 'echo ADDR=$VAULT_ADDR'
           //Below is the identification required by 
        sh 'terraform plan -var="TOKEN=$VAULT_TOKEN"' 
           
         }        
        }
       }                   
      }
  
  

  if (env.BRANCH_NAME == 'master') {
    
    // Run terraform apply
stage('apply') {
    node {
   
    def secrets = [
        [path: 'kv-v1/new', engineVersion: 1, secretValues: [
            [envVar: 'vaultsecret', vaultKey: 'githubtoken']]]]

    // optional configuration, if you do not provide this the next higher configuration
    // (e.g. folder or global) will be used
    def configuration = [vaultUrl: 'http://51a3ab4b.ngrok.io',
                         vaultCredentialId: '403token',
                         engineVersion: 1]
    // inside this block your credentials will be available as env variables
    withVault([configuration: configuration, vaultSecrets: secrets]) {
       // sh 'echo $vaultsecret' 
      // The above command is just to see if there is a reply.
      sh 'terraform apply -auto-approve -var="TOKEN=$vaultsecret"'
      
      // terraform apply -var-file="testing.tfvars"
   }
  }
 }
  
    // End of "if" statement 
     } 
  

   // Run terraform show
    stage('show') {
    // Token addition
      node {
       withCredentials([[
      
      $class: 'VaultTokenCredentialBinding', 
   credentialsId: 'vault-github-access-token', 
   vaultAddr: 'http://51a3ab4b.ngrok.io']]) 
         {    ansiColor('xterm') {
  
        // values will be masked
        sh 'echo TOKEN=$VAULT_TOKEN'
        sh 'echo ADDR=$VAULT_ADDR'
           sh 'terraform show' 
           
         }        
        }
       }                   
      }
      
    
    
    
    
  currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowError) {
  currentBuild.result = 'ABORTED'
}
catch (err) {
  currentBuild.result = 'FAILURE'
  throw err
}
finally {
  if (currentBuild.result == 'SUCCESS') {
    currentBuild.result = 'SUCCESS'
  }
}
