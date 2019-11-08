 provider "github" {
 organization = "${var.github_organization}"
 token        = "${var.TOKEN}"  
  } 

# Example terraform command
 resource "github_membership" "GITHUB_USERNAME" {
 username = "ArranTest"
 role = "member" 
 }

