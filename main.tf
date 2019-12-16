 provider "github" {
 organization = "${var.github_organization}"
 token        = "${var.TOKEN}"  
  } 

# Example terraform command
 resource "github_membership" "irisb1701" {
 username = "irisb1701"
 role = "admin" 
 }



