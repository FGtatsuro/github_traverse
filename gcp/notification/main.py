def notification(event, context):
    """
    Ref.
      https://cloud.google.com/cloud-build/docs/api/reference/rest/v1/projects.builds
      https://cloud.google.com/functions/docs/writing/background
    """

    import base64
    import json
    import os
    import urllib.request

    if not os.environ.get('SLACK_WEBHOOK_URL'):
        return

    if 'data' not in event:
        return

    pubsub_message = json.loads(base64.b64decode(event['data']).decode('utf-8'))
    if pubsub_message['status'] != 'SUCCESS':
        return
    if pubsub_message['substitutions']['REPO_NAME'] != os.environ.get('REPO_NAME'):
        return

    # FYI: https://cloud.google.com/functions/docs/env-var#environment_variables_set_automatically
    slack_message = f"""\
Upload of {os.environ['REPO_NAME']} image is success!
https://console.cloud.google.com/gcr/images/{os.environ['GCP_PROJECT']}/GLOBAL/{os.environ['REPO_NAME']}?project={os.environ['GCP_PROJECT']}
"""
    req = urllib.request.Request(
        url=os.environ.get('SLACK_WEBHOOK_URL'),
        data=json.dumps(
            {
                'text': slack_message
            }
        ).encode('utf-8')
    )
    with urllib.request.urlopen(req) as res:
        pass
    # https://cloud.google.com/functions/docs/writing/background#functions_background_terminate-python
    return
