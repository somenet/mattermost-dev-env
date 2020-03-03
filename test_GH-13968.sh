#!/bin/bash

cd /vagrant/mattermost-server
go run cmd/mattermost/main.go user create --email user@example.com --username admin --password password --system_admin
go run cmd/mattermost/main.go team create --display_name test --name test

export TOKEN=$(curl -s -i -d '{"login_id":"user@example.com","password":"password"}' -H 'Content-Type: application/json' http://localhost:8065/api/v4/users/login | grep "Token: " |sed -Ee 's/^Token: //' -e 's/\r//')
echo "Token is: -${TOKEN}-"

export TEAM_ID=$(curl -s -H "Authorization: Bearer ${TOKEN}" -H 'Content-Type: application/json' http://localhost:8065/api/v4/teams | json_pp | grep '"id"' | sed -Ee 's/\s*"id"\s*:\s*"//' -e 's/".*$//' -e 's/\r//')
echo "TEAM_ID is: -${TEAM_ID}-"

export CHAN_ID=$(curl -s -H "Authorization: Bearer ${TOKEN}" -H 'Content-Type: application/json' http://localhost:8065/api/v4/teams/${TEAM_ID}/channels | json_pp | grep '"id"' | sed -Ee 's/\s*"id"\s*:\s*"//' -e 's/".*$//' -e 's/\r//')
export CHAN_ID=`echo "${CHAN_ID}" | head -1`
echo "CHAN_ID is: -${CHAN_ID}-"

curl -d '{"channel_id": "'${CHAN_ID}'", "message":"asdf", "props":{"attachments":[{"actions": [{"name": "original", "integration": {"url": "http://localhost:31337/cgi-bin/original"}},{"name": "fixed", "integration": {"url": "http://localhost:31337/cgi-bin/fixed"}}]}]} }' -s -H "Authorization: Bearer ${TOKEN}" -H 'Content-Type: application/json' http://localhost:8065/api/v4/posts | json_pp


chmod +x /vagrant/test-GH-13968/cgi-bin/*

cd /vagrant/test-GH-13968
python3 -m http.server --cgi 31337 &


# now
## click yourself into the text-mm team
## add localhost to internal connections
## return to test-team and click on the 2 buttons
