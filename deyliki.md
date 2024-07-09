# Deyliki - let's talk


## 11.06.2024:

* [5c17](https://github.com/viatcheslavmogilevsky/struktura23/commit/5c1747b8fe90c2fe98865f80b40ca6439feb4a32) `Place to keep generated terraform config`
	* Firstly, the only supported syntaxes is JSON - it's generation is way more simpler than native's one.
* [9175](https://github.com/viatcheslavmogilevsky/struktura23/commit/91751a66c9f87a9ceb7d92e3f15ed2bf825f8774) `Introducing deyliki`
	* The idea is to keep some level of enjoy coding every day, even in a worse one


## 12.06.2024:

* [6563](https://github.com/viatcheslavmogilevsky/struktura23/commit/6563c134eac2a4a89ff216399a9bbdb46b18a9ad) `stub json generation`
	* just defining simple entrypoint to return tf json - it returns just some valid JSON string at moment (it is not valid tf conf yet)


## 13.06.2024:

* [ff22](https://github.com/viatcheslavmogilevsky/struktura23/commit/ff2271c89e106a6d190ff97a388fc383a093dfc2) `desired json output from simple example`
	* just explaining how output JSON should look like for simplest example (data.aws_ami in root module)

## 14.06.2024:

* [f291](https://github.com/viatcheslavmogilevsky/struktura23/commit/f2911ac1e73c920fd1b276d339b7a0f68359d82b) `to opentofu (not json string)`
	* define basic structure of JSON-output, return object (hash) - it will be converted to JSON-string anytime later 


## 15.06.2024

* [9f23](https://github.com/viatcheslavmogilevsky/struktura23/commit/9f231ea2da476524e93508b11a4fcd51ac5fcda9) `no needed to stub unknown methods of Base Node`
	* remove extra lines for now, thinking how to export vars from nodes


## 16.06.2024

* [a109](https://github.com/viatcheslavmogilevsky/struktura23/commit/a109209d9520c5b5e0acef714cf10163e2197ccc) `some schemas big shenanigans`
	* introduce mock schemas in a bad way, will refactor it somehow later


## 17.06.2024

* [8d8e](https://github.com/viatcheslavmogilevsky/struktura23/commit/8d8e318c450bc264007122396109ff2746506f0f) `plans for future refactoring`
	* just found yet another place to refactor
* [d244](https://github.com/viatcheslavmogilevsky/struktura23/commit/d244fb42b819a4b11dbad0d44d97001335c601ea) `pave the way to generate variables`
	* but anyway is it clear how to generate variables fron "nodes"
* [55d5](https://github.com/viatcheslavmogilevsky/struktura23/commit/55d510ab99ec6b1e1824d02d5d0b3147e9c51874) `render input at node`
	* render input for node is better at node level


## 18.06.2024

* [63db](https://github.com/viatcheslavmogilevsky/struktura23/commit/63dbfbbc11a4d7353ce91ebc0b1cd80f04e2630e) `input definition`
	* schema class knows what an instance keys can be used in input (variables)
* [0801](https://github.com/viatcheslavmogilevsky/struktura23/commit/080136bd140313a3f6f34bb281b1872458be8739) `opentofu module variables`
	* simple example of how module can render variables from its notes (not recursive yet), also enforced attrs cannot be included in input, as they already set (i.e enforced)


## 19.06.2024

* [78da](https://github.com/viatcheslavmogilevsky/struktura23/commit/78da5d875809a8a30428f16f6a580c6c9fb2d3bd) `output: the beginning`
	* starting rendering output
* [185c](https://github.com/viatcheslavmogilevsky/struktura23/commit/185c55fb2c9e3015ce4a482b635c2b220890513c) `output value`
	* add value to every output item (to correct)


## 20.06.2024

* [197c](https://github.com/viatcheslavmogilevsky/struktura23/commit/185c55fb2c9e3015ce4a482b635c2b220890513c) `resource/data the beginning`
	* starting rendering resource and data


## 21.06.2024

* [7bf8](https://github.com/viatcheslavmogilevsky/struktura23/commit/7bf81d253dfa7bae413cbe64b4b6280024ecb746) `schema provider: the beginning`
	* starting some needed refactoring - to not to copy schemas from owners to nodes/wrappers


## 22.06.2024

* [0ecd](https://github.com/viatcheslavmogilevsky/struktura23/commit/0ecd44d643ec4f54cf501ff992bb7589a5b40f4f) `refactor for better debugging: using schema provider instead of copying schema`
	* this decreases printing the same list mocked schemas, now it just pring BaseSpec descendant
* [fdf7](https://github.com/viatcheslavmogilevsky/struktura23/commit/fdf7d794dc32a6a4da395583348b65135def8328) `NamedSchema: suppress inspecting definition`
	* schemas also can suppress inspecting definition - so number of printed lines is decreased as well


## 23.06.2024

* [7675](https://github.com/viatcheslavmogilevsky/struktura23/commit/767572e8bb9591343547b2e1ef6b692bfcacb270) `any owners can to_opentofu`
	* this will be needed for recursive rendering
* [f058](https://github.com/viatcheslavmogilevsky/struktura23/commit/f058a88cfadf88d5a89a3d064f2d96f848345e15) `wrappers can have their own named wrappers`
	* to allow recursive and named(reusable) modules 
* [406c](https://github.com/viatcheslavmogilevsky/struktura23/commit/406cdbf5fbbffc656784da140b6bea8f7fac48d9) `using keywords for wrapper constructor`
	* initializer params look better now
* [5241](https://github.com/viatcheslavmogilevsky/struktura23/commit/52419a59ebf066ec6f207fa9c87bc6fe03d3f2de) `enforceables can merge`
	* core "resource/data" will be enforced from wrapper block
* [42fa](https://github.com/viatcheslavmogilevsky/struktura23/commit/42fad597649deff6998cef4b4a9c1b10c1954cd5) `remove "provider" from enforcable for clarity`
	* all current code is tightly coupled with opentofu (not flexible, but focus is focus)
* [ae04](https://github.com/viatcheslavmogilevsky/struktura23/commit/ae0422c86122a042e9b97a3f1d223acb14744eef) `json serialization is not needed here`
	* serialization can be done in upper level if it is needed


## 24.06.2024

* [9a01](https://github.com/viatcheslavmogilevsky/struktura23/commit/9a011a1506d2ff7ec4a08834163b2f9a22d51581) `wrapper should have proper core-node`
	* core should be created as Node::Base within wrapper (opentofu module); also removed some unneeded methods


## 25.06.2024

* [0090](https://github.com/viatcheslavmogilevsky/struktura23/commit/009063d2f2c4eab73d11aa02485dd7c15fcd7951)  `recursive opentofu generation: the beginning`
	* the to_opentofu method should located at node level


## 26.06.2024

* [b419](https://github.com/viatcheslavmogilevsky/struktura23/commit/b419d3d68521ac54f2a993ecda158306450b4bf4)  `to_opentofu of node: implementation plan`
	* unfinished plan of how to implement to_opentofu at node (todo: add rendering of wrapper's core)


## 27.06.2024

* [82ca](https://github.com/viatcheslavmogilevsky/struktura23/commit/82ca8e75f9d87e7cb75dc9aed1424c55ed7a6bb9) `recursive to_opentofu-ing: dull implementation`
	* uncorrect implementation just to pave the way to correct one


## 28.06.2024

* [9c1a](https://github.com/viatcheslavmogilevsky/struktura23/commit/9c1abed88bcd7c47d3eb213d1bbaf4b81e059083) `recursive to_opentofu-ing: yet another dull implementation`
	* this implementation is still not correct but closer to correct than previous


## 29.06.2024

* [e66b](https://github.com/viatcheslavmogilevsky/struktura23/commit/e66bbe7ebcb4a19be5861c731db940ff4bf4c357) `recursive to_opentofu-ing: fixing recusrive input (variables)`
	* this implementation is closer to correct than previous by only input/variables


## 30.06.2024

* [9c32](https://github.com/viatcheslavmogilevsky/struktura23/commit/9c32d19a1a7b1ef35b631414477facb5b77da413) `recursive to_opentofu-ing: fixing recursive output`
	* adding recursive output so this impl is closest to correct to date


## 1.07.2024

* [05b7](https://github.com/viatcheslavmogilevsky/struktura23/commit/05b7fe655824ae8139ff75c6b2bcf4acfb735e13) `recursive to_opentofu-ing: inserting core schema into wrapper`
	* wrapper can render core node inside resource/data


## 2.07.2024

* [4f24](https://github.com/viatcheslavmogilevsky/struktura23/commit/4f24c3bfdb47a7b34812f159954b1b5232b92c8f) `recursive to_opentofu-ing: fix deep merge`
	* fixing merging resource/data/module entries at owner (module) level


## 3.07.2024

* [5c26](https://github.com/viatcheslavmogilevsky/struktura23/commit/5c26a2a876b953f4658a9cc37d66a1d2e0eea61b) `recursive to_opentofu-ing: fix internal wrapper's vars/output`
	* add variables and outputs related to wrapper's core


## 4.07.2024

* [7761](https://github.com/viatcheslavmogilevsky/struktura23/commit/776112bc544cca5ef7a776359108a41ab4c3b8fa) `starting adding 'flag to enable' to opentofu-ing`
	* starting to add flag_to_enable -  some refactoring needed already


## 5.07.2024

* [8ad4](https://github.com/viatcheslavmogilevsky/struktura23/commit/8ad457245031cfc4297ade90b2f1c91c80217d4b) `refactoring of opentofu-ing: move outer variables generation into a method`
	*  this is a first part of refactoring which allow to modify opentofu-ing at specific node subclasses


## 6.07.2024

* [91ae](https://github.com/viatcheslavmogilevsky/struktura23/commit/91ae6f0c5cbc25d207d29e3c27748e1f8cf14932) `fixing of refactoring of opentofu-ing: setting variables of internal nodes into named_block`
	* fix setting module variables which relates to module's internal nodes (recursively)


## 7.07.2024

* [6773](https://github.com/viatcheslavmogilevsky/struktura23/commit/677399e8721df6a08159c2419b7de1bc88c9020b) `refactoring of opentofu-ing: move outer outputs generation into a method`
	* adding 'flag to enabled', part 1 - move outputs generation to its own method, so descendants can customize it
* [d34d](https://github.com/viatcheslavmogilevsky/struktura23/commit/d34db1b9562e16df368d64532fc06beace53c064) `refactoring of opentofu-ing: move generation of outer block into a method`
	* adding 'flag to enabled', part 2 - move 'outer block' generation to its own method, so descendants can customize it
* [d441](https://github.com/viatcheslavmogilevsky/struktura23/commit/d4417c9a5efc9aeccc59e11af685a4080031ceb7) `opentofu-ing: 'flag to enabled' added`
	* adding 'flag to enabled', part 3 - customize for Node::Optional
* [e2fe](https://github.com/viatcheslavmogilevsky/struktura23/commit/e2fecb338a6ed51fe9d334cfb6a50f633766019e) `roadmap`
	* more detailed roadmap
* [c1e8](https://github.com/viatcheslavmogilevsky/struktura23/commit/c1e8007b828a16d611840a52449594d45c2603b5) `roadmap: added some items`
	* those items are important enough to be in the roadmap


## 8.07.2024

* [50f8](https://github.com/viatcheslavmogilevsky/struktura23/commit/50f8556b6d5a1b3f694ebca24ec176c1f0a73f5e) `add rspec`
	* initialize rspec as tests are needed


## 9.07.2024

* [f1c3](https://github.com/viatcheslavmogilevsky/struktura23/commit/f1c39e21b45f517fa1608f4b3a3648dbf2510bcf) `rspec: simple data aws_ami: variables`
	* exploring some rspec-expectations features


