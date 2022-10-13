#!/bin/bash

## En local ->
## pig -x local -

## en dataproc...


## create the cluster
##gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project hw-pratal2022-tristanfaine

##gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 4 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project hw-pratal2022-tristanfaine
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 7 --worker-machine-type n1-standard-2 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project hw-pratal2022-tristanfaine


## copy data
##gsutil cp small_page_links.nt gs://myown_bucket/

## copy pig code
##gsutil cp dataproc.py gs://man_from_nanbucket/

## Clean out directory
gsutil rm -rf gs://man_from_nanbucket/out


## run
## (suppose that out directory is empty !!)
gcloud dataproc jobs submit pig --region europe-west1 --cluster cluster-a35a --project hw-pratal2022-tristanfaine -f gs://man_from_nanbucket/dataproc.py

## access results
##gsutil cat gs://man_from_nanbucket/out/pagerank_data_3/part-r-00000

## delete cluster...
gcloud dataproc clusters delete -q cluster-a35a --region europe-west1 --project hw-pratal2022-tristanfaine

