//
//  Author: nholuongut nho
//  Date: 2022-01-25 19:26:05 +0000 (Tue, 25 Jan 2022)
//

// Lists all disabled Jenkins jobs

// Paste this into $JENKINS_URL/script
//
// Jenkins -> Manage Jenkins -> Script Console

jenkins.model.Jenkins.instance.items.findAll { it.isDisabled() }.each{ println it.name }.size
