VIDEOS := $(patsubst %.pcap,%.mpeg,$(wildcard *.pcap))


%.mpeg: %.pcap
	tshark -n -r $< -d udp.port==5100,rtp -V -T fields -e mpeg1.stream | xxd -p -r > $@

all: $(VIDEOS)

clean:
	rm -rf $(VIDEOS)

ifdef DUMP

SRC_IFNAME	= $(shell ip -o r g 8.8.8.8 | cut -d ' ' -f5)
SRC_IP		= $(shell ip -o r g 8.8.8.8 | cut -d ' ' -f7)
SRC_MAC		= $(shell ip -o l sh dev $(SRC_IFNAME) | cut -d ' ' -f 20)
ORIG_SRC_IP	= $(shell tshark -V -r $(DUMP) -d udp.port==5100,rtp -T fields -e ip.src 2> /dev/null | head -n1)
TMP_PCAP	= /tmp/replay.pcap

replay:
	tcprewrite --pnat=$(ORIG_SRC_IP):$(SRC_IP) --enet-smac=$(SRC_MAC) --infile=$(DUMP) --outfile=$(TMP_PCAP)
	sudo tcpreplay --intf1=$(SRC_IFNAME) $(TMP_PCAP)

endif
