# large scale data management

Page rank in Pig, based on https://github.com/momo54/large_scale_data_management which is based on https://gist.github.com/jwills/2047314 .  
Modified for running on Google Cloud Dataproc.

## data

Data is loaded from a public Google Cloud Storage bucket, but is originally sourced from http://downloads.dbpedia.org/3.5.1/en/page_links_en.nt.bz2  

In order to exploit the code and store the output, a bucket needs to be created:

```
gcloud storage buckets create gs://BUCKET_NAME --project=PROJECT_ID  --location=europe-west1 --uniform-bucket-level-access
```

## Cluster creation

Any kind of cluster can be used, but the following command showcases how to modify the number and type of worker machines, for a cluster situated in Western Europe. Please remember to stop or delete the cluster when finished.
```
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 3 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project PROJECT_ID
```


## Running the code

Both Pig and PySpark methods follow the same usage : upload the code to a bucket, clear the output directory if needed, then submit a job:

### Upload code
Pig script
```
gsutil cp dataproc.py gs://BUCKET_NAME/
```

PySpark script
```
gsutil cp pagerank-notype.py gs://BUCKET_NAME/
```

### Clear output directory
```
gsutil rm -rf gs://BUCKET_NAME/out
```

### Submit a job
arguments for submitting the pig and pyspark jobs are different:

```
gcloud dataproc jobs submit pig --region europe-west1 --cluster cluster-a35a --project PROJECT_ID -f gs://BUCKET_NAME/dataproc.py
```

```
gcloud dataproc jobs submit pyspark --region europe-west1 --cluster cluster-a35a gs://BUCKET_NAME/pagerank-notype.py  -- gs://public_lddm_data/page_links_en.nt.bz2 3
```

### Data access example
```
gsutil cat gs://BUCKET_NAME/out/pagerank_data_NUMBER/part-r-00000
```
## Deleting clusters
Delete the cluster when finished.

```
gcloud dataproc clusters delete cluster-a35a --region europe-west1
```

## Performance comparaison

Three different configurations were done in both Pig and PySpark in order to experiment on different cluster sizes and performance:

- 2 nodes : One master (n1-standard-4) and one worker (n1-standard-4)
- 4 nodes : One master (n1-standard-4) and three workers (n1-standard-4)
- 8 nodes : One master (n1-standard-4) and seven workers (n1-standard-2)


The table below showcases the durations for each test:

|           |        Pig | Pyspark |
| :-------: | ---------: | ------: |
| 2 Workers |     49m 36s | 44m 46s |
| 4 Workers |    35m 28s | 36m 27s |
| 8 Workers (underpowered) |    35m 37s | 39m 46s |

### Miscellaneous information

This project took 12.25$ in total from a gcloud free quota plan, but costs only an estimated 7$ due to having to redo some PySpark jobs.
