// This is a Jenkinsfile, when Jenkins is used, it searches a repository and executes files of this name

//The Step below clears the pipeline of potential leftovers of previous runs.
// Technically not needed but nice to ensure errors don’t crop up in the future. 
try {
  stage('checkout') {
    node {
      cleanWs()
      checkout scm
   }
  }

  // This sections runs terraform init 
  stage('init') {
      node {
        // The Credentials binding plugin allows for the Vault token to be associated with the Vault’s address 
       withCredentials([[
      $class: 'VaultTokenCredentialBinding', 
   credentialsId: 'vaulttoken', 
   vaultAddr: 'http://terraform.treehouses.io:8082/']]) 
         {    ansiColor('xterm') {
  
        // The Following checks the Vault for a the desired responce, the address and the token
        // These values will be cencored and will display as *********
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
        // This token is the name of the Token you stored on Jenkins 
   credentialsId: 'vaulttoken', 
        // This is the name of the vault server that you launced  
   vaultAddr: 'http://terraform.treehouses.io:8082/']]) 
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

      // optional configuration, changing the engineVersion to 2]
        def configuration = [vaultUrl: 'http://terraform.treehouses.io:8082/',
                         vaultCredentialId: 'vaulttoken',
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
   credentialsId: 'vaulttoken', 
   vaultAddr: 'http://terraform.treehouses.io:8082/']]) 
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
