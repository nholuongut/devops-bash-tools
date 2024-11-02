//

// Paste this into $JENKINS_URL/script
//
// Jenkins -> Manage Jenkins -> Script Console

//jenkins.model.Jenkins.instance.items.findAll().each { println it.name } // return the whole array, don't want that, just return num
jenkins.model.Jenkins.instance.items.findAll().each { println it.displayName }.size
