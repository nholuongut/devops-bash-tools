//
//  Author: nholuongut nho
//  Date: 2022-01-25 19:26:05 +0000 (Tue, 25 Jan 2022)
//
//  vim:ts=4:sts=4:sw=4:noet

// Paste this into $JENKINS_URL/script
//
// Jenkins -> Manage Jenkins -> Script Console

// XXX: Edit this to the name of your job pipeline
def jobName = "My Dev Pipeline"
def job = Jenkins.instance.getItem(jobName)
job.setDisabled(true)
job.isDisabled()
