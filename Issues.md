# Issues

## Helm Charts
- kured
- oauth2-proxy

## Helm Releases
- kube-prometheus-stack
- home-assistant
- adguard-home
- velero
    Helm install failed: execution error at
        (velero/templates/NOTES.txt:78:4): 


        #################################################################################

        ######   BREAKING: The config values passed contained no longer
        accepted    #####

        ######             options. See the messages below for more
        details.        #####

        ######                                                                     
        #####

        ######             To verify your updated config is accepted, you can
        use   #####

        ######             the `helm template`
        command.                             #####

        #################################################################################


        ERROR: Please make .configuration.backupStorageLocation from map to
        slice


        ERROR: Please make .configuration.volumeSnapshotLocation from map to
        slice


        REMOVED: .configuration.provider has been removed, instead each
        backupStorageLocation and volumeSnapshotLocation has a provider
        configured


        REMOVED: deployRestic has been removed, and it is named deployNodeAgent


        REMOVED: restic has been removed, and it is named nodeAgent

