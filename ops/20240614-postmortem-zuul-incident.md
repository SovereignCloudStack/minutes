# Incident Zuul ZooKeeper outage (2024-06-14)

- Incident: the Zuul VM disk was filled with debug logs. Zuul shut down because of "disk full", containers went down. The biggest problem is the corruption of the ZooKeeper instance
- A recovery is not possible because there's no current backup of ZooKeeper itself
- Incident meeting with @bitkeks, @o-otte, @gtema, @scoopex
- Review of current config:
    - [tenant-config](https://github.com/SovereignCloudStack/zuul/blob/105dbf38033ab279c5d8780679fb9d873a9dc657/ansible/roles/zuul/defaults/main.yml#L92C1-L93C1)
    - [Github-Integration](https://github.com/SovereignCloudStack/zuul-config/blob/main/zuul.d/gh_pipelines.yaml) 
- Recovery process
    - We log into Zuul machine and make a file-system level backup of the container volumes, to save the corrupted data base of ZooKeeper
    - It turns out that at the start of Zookeeper, it loads a snapshot file (which in this case is from yesterday, `Reading snapshot /data/version-2/snapshot.1ccb45d`) and then loads a log file from the `datalog` volume. This one is an incremental diff to the snapshot.
    - The last one of these logs is of size 0 bytes, indicating that the full disk corruption created a 0-byte file and ZooKeeper stops due to a EOF exception (meaning end-of-file, ergo "could not read anything from a 0 byte sized file")
    - We compare the files from the snapshot volume and the ones from the datalog volume and come to the conclusion that the deletion of the latest datalog file might suffice in resolving the EOF exception
    - It is acceptable that Zuul will start with Zookeeper data from yesterday, so we delete the 0 byte file
    - Zookeeper container restarts automatically, successfully loading the database
    - We investigate the state, ok, and start the other containers in a logical order
    - Checking the web frontend is successful, the dashboard shows some pending jobs
    - If there would be any decryption errors, Zuul would indicate it on the dashboard
- TODOs will be talked about in next week's Ops call (2024-06-20) (see agenda there)
    - Even though we could recover the data base, changes to the setup must be followed up on
