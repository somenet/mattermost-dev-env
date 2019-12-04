#!/bin/bash

cd /vagrant/mattermost-server
go run cmd/mattermost/main.go user create --email user@example.com --username admin --password password --system_admin
go run cmd/mattermost/main.go team create --display_name test --name test

export TOKEN=$(curl -s -i -d '{"login_id":"user@example.com","password":"password"}' -H 'Content-Type: application/json' http://localhost:8065/api/v4/users/login | grep "Token: " |sed -Ee 's/^Token: //' -e 's/\r//')
echo "Token is: -${TOKEN}-"

export TEAM_ID=$(curl -s -H "Authorization: Bearer ${TOKEN}" -H 'Content-Type: application/json' http://localhost:8065/api/v4/teams | json_pp | grep '"id"' | sed -Ee 's/\s*"id"\s*:\s*"//' -e 's/".*$//' -e 's/\r//')
echo "TEAM_ID is: -${TEAM_ID}-"



curl -d '{"team_id": "'${TEAM_ID}'", "method": "G", "trigger": "c1", "url": "http://localhost:31337/original.json"}' -s -H "Authorization: Bearer ${TOKEN}" -H 'Content-Type: application/json' http://localhost:8065/api/v4/commands | json_pp
curl -d '{"team_id": "'${TEAM_ID}'", "method": "G", "trigger": "c2", "url": "http://localhost:31337/fixed.json"}' -s -H "Authorization: Bearer ${TOKEN}" -H 'Content-Type: application/json' http://localhost:8065/api/v4/commands | json_pp


mkdir -p /vagrant/test-ws
echo '{"text": "Original\n```haskell\nlet\n\nf1 = [ 3 | a <- [1]]\nf2 = [ 4 | b <- [2]]\nf3 = \\p -> 5\n\nin 1\n```", "response_type": "in_channel"}' > /vagrant/test-ws/original.json
echo '{"text": "Fixed\n```haskell\nlet\n\nf1 = [ 3 | a <- [1]]\nf2 = [ 4 | b <- [2]]\nf3 = \\p -> 5\n\nin 1\n```", "response_type": "in_channel", "skip_slack_parsing":"true"}' > /vagrant/test-ws/fixed.json

cd /vagrant/test-ws
python3 -m http.server 31337 &


# now
## click yourself into the text-mm team
## add localhost to internal connections
## return to test-team and call /c1 (original) and /c2 (fixed).
