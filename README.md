# RTP MPEG-ES extract and replay

Extract mpeg stream from pcap. Replay pcap.

## Extract video from pcaps

Extract MPEG stream from network session dump and place it next with .mpeg suffix.


```bash
make all
```

## Replay pcap

Take dump and replay it replacing source ip and mac with host's one.

```bash
make DUMP=dump.pcap replay
```
