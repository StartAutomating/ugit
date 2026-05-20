@{
    name = 'PublishTestResults'
    uses = 'actions/upload-artifact@main'
    with = @{
        name = 'PesterResults'
        path = '**.TestResults.xml'
    }
    if = '${{always()}}'
}

