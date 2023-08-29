# AWS STS Helper

This provides two bash scripts to help take the pain from `get-session-token` and `assume-role` calls.

# Install

You need jq

## Windows

Run in elevated git bash:

`curl -L -o /usr/bin/jq.exe https://github.com/stedolan/jq/releases/latest/download/jq-win64.exe`

## Other

https://stedolan.github.io/jq/download/

# Run

### Run Globally

Linux or git bash on Windows.

Run from this repo root.

```
./set-aliases.sh
```

Run from home dir or restart terminal:

```
source ~/.bashrc
```

### Get Session Token

To get a session token for `my_user`:

~/.aws/credentials
```
[my_user]
aws_access_key_id = <ID>
aws_secret_access_key = <SECRET>
```

~/.aws/config
```
[profile my_user]
region = eu-central-1
output = json
mfa_serial = arn:aws:iam::<ACC_ID>:mfa/my_user
```

Run:

```
./get-session-token.sh
```

Choose:

```
my_user
```

The temporary credentials will be stored as profile:

```
[my_user_temp]
aws_access_key_id = <ID>
aws_secret_access_key = <SECRET>
aws_session_token = <TOKEN>
```

### Assume Role

To get a session token for `my_user_deployment_role`:

~/.aws/credentials
```
[my_user]
aws_access_key_id = <ID>
aws_secret_access_key = <SECRET>
```

Note - use `[profile ...`

~/.aws/config
```
[profile my_user]
region = eu-central-1
output = json
mfa_serial = arn:aws:iam::<ACC_ID>:mfa/my_user

[profile my_user_deployment_role]
region = eu-central-1
output = json
source_profile = my_user
role_arn = arn:aws:iam::<ACC_ID>:role/deployment_role
```

Run:

```
./assume-role.sh
```

Choose:

```
my_user_deployment_role
```

The temporary credentials will be stored as profile:

```
[my_user_deployment_role_temp]
aws_access_key_id = <ID>
aws_secret_access_key = <SECRET>
aws_session_token = <TOKEN>
```
