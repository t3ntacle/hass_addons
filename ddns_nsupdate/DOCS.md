## NSupdate DDNS Updater

This addon is used to update a DDNS record using nsupdate (rfc2136) protocol

## Requirements
* your DNS server or servers must be configured to accept RFC 2136 DNS Update requests 

## Configuration

```yaml
config:
  - key_name: K{name}.+{alg}.+{random}
    hmac_key: <hmac key from bind key>
    server: <dns server address>
    zone: <dns zone to modify>
    hostnames: my.example.com,www.example.com
  - hmac_key: <hmac key from bind key>
    server: <dns server address>
    zone: <dns zone to modify>
    hostnames: other.example.com
```
## Key generation
You must generate a TSIG key (with, for example, a tool like dnssec-keygen), 
configure your DNS server to accept only those DNS updates signed by that key, 
and then create a key file for ddclient+nsupdate to use.

There are two supported key file formats. The first is a pair of symmetric key
files output by dnssec-keygen (or similar tools) with the same name but different
extensions (one ends in .key and the other in .private). When specifying the
key file in your ddclient configuration options, you use the path to the file
with the .key extension, and nsupdate uses it and replaces the extension with
.private to obtain the second key file. However, newer versions of dnssec-keygen
generate newer key file formats that nsupdate might not understand. A more
reliable option is to create a key file containing a named-compatible key
statement and specify the full path to that (with extension) in your ddclient
configuration.


## How it works

The addon will check the current public IP address of the home network and update the DDNS record for the domains in the configuration.
