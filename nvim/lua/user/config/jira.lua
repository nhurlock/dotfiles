local env = require('user.env')

return {
  discovery_url = env.DISCOVERY_URL,
  azure = {
    token_url = env.AZURE_TOKEN_URL,
    client_id = env.AZURE_DISCOVERY_CLIENT_ID,
    client_secret = env.AZURE_DISCOVERY_CLIENT_SECRET,
    app_id = env.AZURE_DISCOVERY_APP_ID,
  },
  jira = {
    issues_url = env.JIRA_ISSUES_URL,
    projects = env.JIRA_PROJECTS,
    issue_types = { 'Story', 'Bug', 'Engagement', 'Access', 'Support Request' },
  },
}
