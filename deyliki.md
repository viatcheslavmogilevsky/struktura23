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


## 10.07.2024

* [0bf2](https://github.com/viatcheslavmogilevsky/struktura23/commit/0bf26ecb6941b41da626d95a332879b5db9243b6) `rspec: simple data aws_ami: variables`
	* rspec: testing simple outside variables generation


## 11.07.2024

* [6d10](https://github.com/viatcheslavmogilevsky/struktura23/commit/6d10688e00cc4f8f310ceee2e3566eb4453db5d9) `rspec: simple data aws_ami: variables`
	* rspec: testing simple outside output generation
* [474c](https://github.com/viatcheslavmogilevsky/struktura23/commit/474c3caf126cae5e6070fea67a973ee281c9aad0) `remove suppress_definition`
	* it is not needed anymore since starting testing


## 12.07.2024

* [e98d](https://github.com/viatcheslavmogilevsky/struktura23/commit/e98d3fceed9a2faa6b30add90fdf880989050576) `rspec: simple data source`
	* rspec: testing simple data sources generation


## 13.07.2024

* [b1ab](https://github.com/viatcheslavmogilevsky/struktura23/commit/b1ab4d49379e9fd445e6866a51ff3f3aae662fea) `rspec: simple data resource`
	* rspec: testing simple resources generation if there is no resource blocks (empty)


## 14.07.2024

* [1605](https://github.com/viatcheslavmogilevsky/struktura23/commit/1605213961068ac4da7e927846058295f0b68b9c) `rspec: simple data: module`
	* rspec: testing simple modules generation if there is no module blocks (empty)


## 15.07.2024

* [d41f](https://github.com/viatcheslavmogilevsky/struktura23/commit/d41fb3f829d09bcb6e25aa2f9a55c7d65e8e1f5d) `rspec: simple data: metadata (stub at the moment)`
	* rspec: testing terraform-config/provider-config/locals generation (stub)


## 16.07.2024

* [b340](https://github.com/viatcheslavmogilevsky/struktura23/commit/b3402064e4f706a688e3aeb8846cff10e1867afd) `rspec: simple data: datasource aws_ami main`
	* rspec: testing simple data sources generation: exact datasource tf block


## 17.07.2024

* [e771](https://github.com/viatcheslavmogilevsky/struktura23/commit/e77124d56c09cd569771e9a2358f8cfd888159d8) `rspec: simple data: datasource aws_ami main full block`
	* rspec: testing simple data sources generation: exact full datasource tf block


## 18.07.2024

* [202f](https://github.com/viatcheslavmogilevsky/struktura23/commit/202ff6ad51c2a38108877faa3c3c5bc04931d28c) `rspec: rename one test file`
	* rspec: renaming test file (with AwsAmiDataRootSimple) to correct name
* [5060](https://github.com/viatcheslavmogilevsky/struktura23/commit/50602d19ec43ac40babcf5f09c4e5b1977d4645f) `rspec: eks with nodes: the beginning`
	* rspec: testing eks-with-nodes: test opentofu method (basic)


## 20.07.2024 (19.07.2024 CEST)

* [38a6](https://github.com/viatcheslavmogilevsky/struktura23/commit/38a61ba03553f2a3a28cb6b4c582526377800975) `rspec: simple data: metadata (stub at the moment)`
	* rspec: testing eks-with-nodes terraform-config/provider-config/locals generation (stub)


## 20.07.2024

* [face](https://github.com/viatcheslavmogilevsky/struktura23/commit/face42fcece83389a6b4f8530c315cc69af504b0) `rspec: eks with nodes: variables/resource/data/module`
	* rspec: testing eks-with-nodes high-level: variables, resources (empty at top-level), datasources(empty at top-level) and modules(some)


## 21.07.2024

* [a298](https://github.com/viatcheslavmogilevsky/struktura23/commit/a2985464d9f199b663cd816f3274d566ca2078ab) `rspec: eks with nodes: output`
	* rspec: testing eks-with-nodes high-level: output (some)


## 22.07.2024

* [1370](https://github.com/viatcheslavmogilevsky/struktura23/commit/13700c25bc47e244510d996915ed4f9b16300e7e) `rspec: eks with nodes: variables of aws_ami datasource`
	* rspec: testing eks-with-nodes high-level: variables - test inclustion of aws_ami data source (aws_eks_cluster_main_aws_launch_template_common_launch_template_aws_ami_main)


## 23.07.2024

* [5a2a](https://github.com/viatcheslavmogilevsky/struktura23/commit/5a2aef3889e89b3d6bb8890553fe490c34c6bed7) `rspec: eks with nodes: variables of aws_ami datasource (all)`
	* rspec: testing eks-with-nodes high-level: variables - test inclustion of aws_ami data sources (all cases)


## 24.07.2024

* [e06a](https://github.com/viatcheslavmogilevsky/struktura23/commit/e06ae21a5a2dde1dbdce96c5716d30c48ada1ed7) `rspec: eks with nodes: "(at)resource_aws_launch_template_schema" intro`
	* rspec: testing eks-with-nodes high-level: variables - introduction the schema of launch template


## 25.07.2024

* [65a7](https://github.com/viatcheslavmogilevsky/struktura23/commit/65a7891e2ca75e22f8d0c5248877754e67579d55) `rspec: eks with nodes: "(at)resource_aws_launch_template_schema": variables`
	* rspec: testing eks-with-nodes high-level: variables - the schema of launch template - cover all related variables


## 26.07.2024

* [26c5](https://github.com/viatcheslavmogilevsky/struktura23/commit/26c54a0b09612339ac757da7b015ccc19911f033) `rspec: eks with nodes: variables: test flag_to_enable`
	* rspec: testing eks-with-nodes high-level: variables: test of 'flag_to_enable' of Struktura23::Node::Optional


## 27.07.2024

* [d4b2](https://github.com/viatcheslavmogilevsky/struktura23/commit/d4b2ad6db60a6fa6e1b2249491badf850ef82124) `rspec: eks with nodes: output: aws_ami related output (one case)`
	* rspec: eks-with-nodes high-level testing: output: test inclustion of aws_ami data source (just one case)


## 28.07.2024

* [df89](https://github.com/viatcheslavmogilevsky/struktura23/commit/df89330943c6a43ddfa6bf16b4200dc8340e0a55) `rspec: eks with nodes: output: aws_ami related output (all cases)`
	* rspec: eks-with-nodes high-level testing: output: the schema of aws ami datasource - cover all related cases


## 29.07.2024

* [7322](https://github.com/viatcheslavmogilevsky/struktura23/commit/7322a32a5c2f41ce084da7c61c5e91f64d63fa51) `rspec: eks with nodes: output: aws launch template related output (one case)`
	* rspec: eks-with-nodes high-level testing: output: test inclustion of aws_launch_template resource (just one case)


## 30.07.2024

* [5ef8](https://github.com/viatcheslavmogilevsky/struktura23/commit/5ef8217f2c23ae2e7d4e0b9fedba709fe17d78a4) `rspec: eks with nodes: module: existence of modules and their 'contents'`
	* rspec: eks-with-nodes high-level testing: modules: existing of target modules and check value at their 'content' key


## 31.07.2024

* [53a7](https://github.com/viatcheslavmogilevsky/struktura23/commit/53a72324d57c16d037cdc7afcdcace4709dc49b0) `rspec: eks with nodes: module: contents of 'contents' (aws_launch_template)`
	* rspec: eks-with-nodes high-level testing: modules: check internals of 'module' (no passed yet)

## 1.08.2024

* [fce8](https://github.com/viatcheslavmogilevsky/struktura23/commit/fce8e1bccc99371587049a6670471d781302883c) `rspec: eks with nodes: module: contents of 'contents' (aws_launch_template): fix`
	* rspec: eks-with-nodes high-level testing: modules: check internals of 'module' (fix tests)
* [2e29](https://github.com/viatcheslavmogilevsky/struktura23/commit/2e29502ce6bbe4bcfe15dba9ac1d22aa86bdc2ac) `rspec: eks with nodes: module: contents of 'contents' (aws_ami datasource)`
	* rspec: eks-with-nodes high-level testing: modules: check aws_ami-related internals of 'module


## 3.08.2024 (2.08.2024 CEST)

* [6c14](https://github.com/viatcheslavmogilevsky/struktura23/commit/6c14677d4653186ca086c2df90daf9d040a96614) `rspec: eks with nodes: aws_eks_cluster_main module: test flag_to_enable`
	* rspec: testing eks-with-nodes: test of 'flag_to_enable' of Struktura23::Node::Optional (in aws_eks_cluster_main's module)


## 3.08.2024

* [bc79](https://github.com/viatcheslavmogilevsky/struktura23/commit/bc79723abb1b909c0a2e63a9f56c595f48b5f4ee) `rspec: eks with nodes: aws_eks_cluster_main module: contents (variables count)`
	* rspec: eks-with-nodes high-level testing: modules: contents: dedicated examples plus checks count of keys of 'variables'


## 4.08.2024

* [4aa3](https://github.com/viatcheslavmogilevsky/struktura23/commit/4aa36396c720644b7ddddb70d4aaad5c0fce5174) `rspec: eks with nodes: aws_eks_cluster_main module: contents (what is includes in 'variables')`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'variables' (instead of count)


## 5.08.2024

* [85a0](https://github.com/viatcheslavmogilevsky/struktura23/commit/85a06ea9d8a492fcb807709adb864a6ecefd7f2e) `rspec: eks with nodes: aws_launch_template_launch_template module: contents (what is includes in 'variables')`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'variables' (instead of count, aws_launch_template_launch_template)


## 6.08.2024

* [7413](https://github.com/viatcheslavmogilevsky/struktura23/commit/741348b8f58d4d682a17079733487c228af6343f) `rspec: eks with nodes: module contents variable: move to dedicated example`
	* rspec: eks-with-nodes high-level testing: modules: contents: variables: move checks under dedicated example


## 7.08.2024

* [cc9f](https://github.com/viatcheslavmogilevsky/struktura23/commit/cc9f5915f3202edde0681d39b4b89c46d031a692) `rspec: eks with nodes: module contents: check what is included`
	* rspec: eks-with-nodes high-level testing: modules: contents: check whether known keys ("variables", "resource", "data", "output", "module", ...) are included


## 8.08.2024 :cat:

* [c67f](https://github.com/viatcheslavmogilevsky/struktura23/commit/c67ffe0c76fb0dbebdd330bc4bc60a1cfd2ba35a) `rspec: eks with nodes: module contents: resource`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'resource'


## 9.08.2024

* [6b91](https://github.com/viatcheslavmogilevsky/struktura23/commit/6b916e2ab25d0a4f4d5b3c34f693ebcd4045098a) `rspec: eks with nodes: module contents: data`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'data'
