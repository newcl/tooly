What the purpose of this design 
- TinyURL like service 
    - Provide long url and return shorter one in the format of /abcDEF10
    - When provide the key back, redirect to the real service 
    - Customizable URL 
    - TTL 
    - Delete on demand
    - Permission control
    - All my tinys

Baselin
- google serves 40,000 40K search request per secon 
- 3,500,000,000 3.5 billion per day 
- 1,200,000,000,000 1.2 trillion per year

Requirements 
- 10MM writes per day 
    - 10,000,000 / 24 / 60 / 60 = 115 write / s
- 10X read 
    - 1150 read / s


Design goal

98 -> https://www.reddit.com/r/buildapc/comments/jqacl8/starting_with_my_first_pc_build_the_white_beast/
Assume each URL is about 128 
- (it says < 2000 here)
    - https://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-a-url-in-different-browsers



Alphabet 
- [a-z][A-Z][0-9]
    - 26 + 26 + 10 = 62 
    - Math.pow(62, 11)
        >>> int(math.pow(62, 11))
        52036560683837095936L
        >>> math.pow(62, 11)
        5.20365606838371e+19
        >>> math.pow(62, 11) / 10000000 / 365
        14256591968.174547 
- [a-z][A-Z][0-9][-._~] 
    - 26 + 26 + 10 + 4 = 66 
Tiny - structure to store the data internally
- key
    - https://www.youtube.com/watch?v=moOxq_8l_34 <- very recent trending video the alpha bet is likely changed 
    - https://www.youtube.com/watch?v=KHXF4esrKmg
    - 11 character 
    - VARCHAR(11)
    - 11 bytes
- original url 
    - max 2048 characters 
    - expect most will be less than 256
    - VARCHAR(2048)
    - expected 256 bytes

- created by 32 character (angelleecash)
    - VARCHAR(32)
    - 32 bytes
- created at (timestamp) 8 bytes postgresql
    - timestamp type 
    - 8 bytes
- who can visit 
    - json field 
    - amy,michael,dan 
    - expect 10 people 
    - 256 bytes 
- TTL
    - timestamp 
    - 8 bytes

key (11) + original url (256) + created by (32) + created at (8) + who can visit (256) + TTL (8)
= 11 + 256 + 32 + 8 + 256 + 8 = 571 (512)

Storage 
- Write 
    - 115 write /s 
    - 115 * 24 * 60 * 60 * 512 = 4G per day 
    - 1.5T per year 

- Read
    - 1150 read /s = 40G per day 



Business logic 
- Given a long url 
- Get a key 
- Store all fields 

Requirement
- Availability 
- Security 
    - Same url different key 
    - Can not guess how the key is generated

Feature 
- Given a long url return a shorter one or the original url
- TTL


Solution 1
- Total randomness 
Roll the dice 11 times (guarantee no empty key)
- 10 within ALPHABET+NULL
- 1 within ALPHABET 

- Pro
    - Realtime generation of keys with very little probability to collide 
    - Simple to implement Generate Key and if collide just repeat
- Con
    - Need a real good random generator
    - Collision when majority space is already consumed (!!!very unlikely)

- Pre computed keys 
Generate keys offline and then distribute by app servers

- Pro
    - Fully control how keys are generated 
        - When running out of keys and always increase length / alphabet size
- Con 
    - Need to manange the key space 


- Digest input url

TinyService 
- Manage key spaces 
- Recycle keys
- Reuest key ranges / keys from key service
- Respond to customer requests to allocate key, write to storage 

Storage 
- Key -> {} storage 
- Get list of available keys 