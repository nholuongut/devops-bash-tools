//


// List all Jenkins jobs prefix with whether they are enabled or disabled

// Paste this into $JENKINS_URL/script
//
// Jenkins -> Manage Jenkins -> Script Console

jenkins.model.Jenkins.instance.items.findAll().each { println "disabled: ${it.isDisabled()}\t\tname: ${it.name}" }.size
