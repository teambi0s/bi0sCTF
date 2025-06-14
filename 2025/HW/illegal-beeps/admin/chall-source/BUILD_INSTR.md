```bash
sudo apt install docker.io
docker pull espressif/idf:release-v5.1
```

```bash
docker run --rm -it -v $PWD:/workspace -w /workspace espressif/idf:release-v5.1
idf.py set-target esp32
idf.py build
```