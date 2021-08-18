# OpcUA-empy
Demo OpcUA BS with Embedded Python.

This demo starts an OpcUA server (100 nodes) and queries them using InterSystems IRIS and EmbeddedPython.

![](architecture.png)

# Running

1. Install [Docker](https://www.docker.com/get-started) with docker-compose.
2. Clone or download this repository: `git clone git@github.com:eduard93/OpcUA-empy.git`
3. Copy `iris.key` into the repository.
4. Start containers: `docker compose up -d`
5. Check that `QueryService` business service in `USER` namespace is running.

# SQL

1. `dc_opcua.Node` table contains auto-discovered nodes.
2. `dc_opcua.Value` table contains node values.

# SMS

Send SMS via AWS SNS. AWS SMS is a paid service. [Pricing](https://aws.amazon.com/sns/sms-pricing/).

1. In the `.env` file set your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. Optionally adjust `AWS_DEFAULT_REGION`.
2. Restart the `iris` container for the new environment variables to take effect. 
3. Go to: `AWS Management Console` > `Simple Notification Service` > `Text messaging (SMS)`, switch to the `AWS_DEFAULT_REGION` if needed.
4. If your account is in `SMS sandbox` (default), go to `Sandbox add phone number` > `Add a phone number` and add your phone number.
5. In `SMS` Business Operation, set the `phone` setting to your phone number.
6. Test `SMS` Business Operation by sending a `Ens.StringContainer` request to it.



# Customization

1. To customize the OpcUA server, provide an `entrypoint` for the `opcua` container in `docker-compose.yml`, for example: 

```
entrypoint: ["python", "/app/server.py", "--nodes", "10", "--sleep", "0.1"]
```

Available parameters are:
- `--nodes` - number of nodes to create (default: 100).
- `--sleep` - pause between node value changes (default: 0.1).

2. To customize query frequency, set `Call Interval` value in `QueryService` business service (default: 5 seconds).

3. To customize server, namespace, and parent node (InterSystems IRIS queries all children of this node), edit `OpcUA` setting category in `QueryService` business service.