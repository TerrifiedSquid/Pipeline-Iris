 provider "github" {
 organization = "${var.github_organization}"
 token        = "${var.TOKEN}"  
  } 

# Example terraform command
 resource "github_membership" "FlashteamTango" {
 username = "FlashteamTango"
 role = "member" 
 }



