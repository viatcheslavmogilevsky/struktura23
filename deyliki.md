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


## 10.08.2024

* [f16b](https://github.com/viatcheslavmogilevsky/struktura23/commit/f16b96cbaecca5b436d89bbf6bfe0bc8f703b094) `rspec: eks with nodes: module contents: output (1)`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'output' (aws_launch_template_launch_template)


## 11.08.2024

* [cb84](https://github.com/viatcheslavmogilevsky/struktura23/commit/cb84694c33c6c82999b7d90bb233bf199646786d) `rspec: eks with nodes: module contents: output (2)`
* [4860](https://github.com/viatcheslavmogilevsky/struktura23/commit/4860c47baa5fc894fed460f99b434b0de914de7c) `rspec: eks with nodes: module contents: output (2)`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'output' (aws_eks_cluster_main)


## 12.08.2024

* [da89](https://github.com/viatcheslavmogilevsky/struktura23/commit/da89b038b772f9a541deab62b6e50492debe4fa7) `rspec: eks with nodes: module contents: output (3)`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'output' (aws_eks_cluster_main) - other case


## 13.08.2024

* [ee10](https://github.com/viatcheslavmogilevsky/struktura23/commit/ee103b10a002706b2d34f2bc3c945d75053c7ce4) `rspec: eks with nodes: module contents: output (4)`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'output' (aws_eks_cluster_main) - almost all cases


## 14.08.2024

* [9922](https://github.com/viatcheslavmogilevsky/struktura23/commit/9922bf28c28f7a753db87ea3824f8a9642288c84) `rspec: eks with nodes: module contents: output: module (keys)`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'modules' - keys


## 15.08.2024

* [913f](https://github.com/viatcheslavmogilevsky/struktura23/commit/913fca79e6cac190592f2b841468ae11b2cee136) `rspec: eks with nodes: module contents: output: provider/locals/terraform`
	* rspec: eks-with-nodes high-level testing: modules: contents: terraform-config/provider-config/locals generation (stub)


## 16.08.2024

* [c7d6](https://github.com/viatcheslavmogilevsky/struktura23/commit/c7d6a6a6bb89538ddacce7806bdfca2058e136cd) `rspec: eks with nodes: module contents: output: module (what is included)`
	* spec: eks-with-nodes high-level testing: modules: contents: check what is included in 'modules' - it's own internal contents - module blocks


## 17.08.2024

* [2a8f](https://github.com/viatcheslavmogilevsky/struktura23/commit/2a8f46720d9d5d30f7e1a45b6edf2cc4e2f8ac6d) `rspec: eks with nodes: module contents: output: module (flag to enable)`
	* rspec: eks-with-nodes high-level testing: modules: contents: check what is included in 'modules' - test of 'flag_to_enable' of Struktura23::Node::Optional


## 19.08.2024

* [a0af](https://github.com/viatcheslavmogilevsky/struktura23/commit/a0afde26a2699987259a2903a090ea1058b64c54) `rspec: eks with nodes: module contents: module (recursive)`
	* rspec: eks-with-nodes high-level testing: modules: contents: check recursive 'modulea/contents'


## 20.08.2024

* [e49d](https://github.com/viatcheslavmogilevsky/struktura23/commit/e49d92e857530f56a27a7e22d52c13b056b1b83b) `docs: start working on new design`
	* docs: need to switch to new design :)


## 21.08.2024

* [4de6](https://github.com/viatcheslavmogilevsky/struktura23/commit/4de6bc817635872ef7b308ea27f58ed540dfc004) `docs: start working on new design: new file`
	* docs: need to switch to new design - started new file


## 22.08.2024

* [a4d5](https://github.com/viatcheslavmogilevsky/struktura23/commit/a4d54be367defc3bb625ae804920304e2df81cf9) `Update new_design.md`
	* docs: new design: example as class definition


## 23.08.2024

* [9684](https://github.com/viatcheslavmogilevsky/struktura23/commit/96844771cf97fa2d155dd9ee647163964eb51d1f) `docs: start working on new design: new file: has_root/has_anything`
	* docs: new design: example of spec's root and has_xyz (simple)


## 26.08.2024

* [85e5](https://github.com/viatcheslavmogilevsky/struktura23/commit/85e531a9c5a1ba20cfc5ccefa268a8f5fc8dd164) `docs: start working on new design: remember to make scheme`
	* docs: new design: remember to draw scheme (diagram) later


## 27.08.2024

* [5ffb](https://github.com/viatcheslavmogilevsky/struktura23/commit/5ffb7df5d542b7045d50df4da04acc86961d74d5) `docs: start working on new design: scheme start`
	* docs: new design: starting drawing diagram (idea)


## 28.08.2024

* [4676](https://github.com/viatcheslavmogilevsky/struktura23/commit/46762239100bb5260e295a99bddb0613bddd0a4b) `docs: start working on new design: simplify user code`
	* docs: new design: simple code example (single line lambda)


## 29.08.2024

* [663a](https://github.com/viatcheslavmogilevsky/struktura23/commit/663a183d5084e6fbc6189d5b526cd3c8b1a70edb) `docs: start working on new design: compound example: the beginning`
	* docs: new design: simple code example: starting to write example of reusable structs (compound???)


## 30.08.2024

* [4c69](https://github.com/viatcheslavmogilevsky/struktura23/commit/4c69aa5339136ff18f1cd89036ac44f877096de8) `docs: start working on new design: has_many eks node group`
	* docs: new design: simple code example: exampple of eks-cluster - eks-node-group ownership (not finished)


## 31.08.2024

* [bffb](https://github.com/viatcheslavmogilevsky/struktura23/commit/bffba36041f60af34efe2b121c94439d0e2cbbc9) `docs: start working on new design: belongs_to`
	* docs: new design: simple code example: introduction of belongs_to - reverse relationship (not finished)


## 1.09.2024

* [5d64](https://github.com/viatcheslavmogilevsky/struktura23/commit/5d649fee4f7ac03c091f0a88c22cd7f0b51640b2) `docs: new design: rename arg for readability`
	* docs: new design: rename arg for 'where' func to be consistent with cases where 'belongs_to' is used
* [7c98](https://github.com/viatcheslavmogilevsky/struktura23/commit/7c985fd85e9ee06cc38f231ddda882b92a6b68f2) `docs: new design: belongs_to (complete)`
	*  docs: new design: simple code example: introduction of belongs_to - reverse relationship (finished)


## 3.09.2024

* [579e](https://github.com/viatcheslavmogilevsky/struktura23/commit/579e36565ba6cc8975a374a0c59576bae5d4ed8f) `docs: new design: enforce example (not 100 percent complete)`
	*  docs: new design: simple code example: introduction of enforce - 2nd time, and there are more questions now


## 4.09.2024

* [e9ff](https://github.com/viatcheslavmogilevsky/struktura23/commit/e9ff9c55b42c36a781d421404c45afc62c2db457) `docs: new design: enforce example: aws_ami and launch template`
	* docs: new design: simple code example: optinal ami for launch template (not complete I think)


## 5.09.2024

* [6929](https://github.com/viatcheslavmogilevsky/struktura23/commit/6929ae98f945518d63d7866e20333076e1e8afe0) `docs: new design: enforce example: node/optional_node`
	* docs: new design: introduction of node/oprional_node for enforcing (still not complete I think)


## 6.09.2024

* [31be](https://github.com/viatcheslavmogilevsky/struktura23/commit/31bef2e5804c8ef354cd8a6ea3ad4e88d695e9fc) `docs: new design: enforce example: found_node`
	* docs: new design: found_node instead of plain 'node' - but it's still not complete yet


## 7.09.2024

* [9b07](https://github.com/viatcheslavmogilevsky/struktura23/commit/9b078cd620d4801d770e798ca091018d3a641f91) `docs: new design: found_at: intro`
	* docs: new design: found_at - introduction plus optional chaining example (aws_ami)


## 8.09.2024

* [fd69](https://github.com/viatcheslavmogilevsky/struktura23/commit/fd693ee1358150a190444a36b3d89d58fcfcc405) `docs: new design: found_at: enforce_expr intro`
	* docs: new design: intro of found_at? and enforce_expr - to apply complex assignments


## 9.09.2024

* [cd4a](https://github.com/viatcheslavmogilevsky/struktura23/commit/cd4a1cf8f28b3ca6c6fd27729845a9b183e33b47) `docs: new design: found_at: recursive example (not nice yet)`
	* docs: new design: enforce by non-owner (recursive) - not a nice example


## 10.09.2024

* [766f](https://github.com/viatcheslavmogilevsky/struktura23/commit/766f8cbd43c9d9f5fa037af5f438bcf2b4ba5732) `docs: new design: found_at: 'recursive example' (better)`
	* docs: new design: enforce by non-owner (recursive) - better example


## 11.09.2024

* [3774](https://github.com/viatcheslavmogilevsky/struktura23/commit/377493ce5835b1b276731ed167f6c708fd033de6) `docs: new design: new variant of example`
	* docs: new design: more simple variant of example - avoid using anonymous functions (lambdas) where possible


## 12.09.2024

* [322a](https://github.com/viatcheslavmogilevsky/struktura23/commit/322a4bdbdb8fa56eb5bfbbffa18e22c27bd6274a) `docs: new design: identify_by instead of identify_by`
	* identify_by is 'bidirectional' can be used for importing existing resources and to 'enforce' for_each
* [cebd](https://github.com/viatcheslavmogilevsky/struktura23/commit/cebde16bbe7daa8725e155468324dcb6101f555f) `docs: new design:  better enforce_expression`
	* enforce_expression interface is closer to enforce (attr=>val)
* [60f4](https://github.com/viatcheslavmogilevsky/struktura23/commit/60f474546c5a9cceae1a9e5cd178ef2b80ff49b8) `docs: new design: launch template: identify_by name instead of id`
	* id is not so good to be used as resource key


## 13.09.2024

* [3636](https://github.com/viatcheslavmogilevsky/struktura23/commit/363658e3f42a1e208153c872eaebe9d32d437809) `docs: example of how to use specs (not clear yet)`
	* an non-clear example of Struktur23 usage - focus on generating opentofu first?


## 14.09.2024

* [3387](https://github.com/viatcheslavmogilevsky/struktura23/commit/3387b83bb8fcf066e355af4083efd7b0e85cc4a7) `module-spec instead of base-spec: the beginning`
	* starting implementing 'new design' in different class


## 15.09.2024

* [5db5](https://github.com/viatcheslavmogilevsky/struktura23/commit/5db531872cb56b2137063a36fb9e25586900449b) `new design: example of result spec in quasi-hcl (quasi opentofu)`
	* how a generated opentofu module would be like in quasi-hcl (indeed real modules will be in JSON), next: how queries would like


## 16.09.2024

* [fbaf](https://github.com/viatcheslavmogilevsky/struktura23/commit/fbaf80edf1aa08bd267a7cd483dd18b0233963f0) `new design: tls_certificate belongs to open_connect_provider`
	* tls_certificate here does make sense to enforce attribute of openid_connect_provider, and if latter is optional the tls_certificate is optional too
* [3e07](https://github.com/viatcheslavmogilevsky/struktura23/commit/3e0753dac57933fed02c1e3897bddebf5634f8cb) `new design: example of result query in quasi-sql`
	* how quasi-SQL queries would look like (actually they are 'describe' API requests) - it still is not 100% informative because 'import script' is not shown yet


## 17.09.2024

* [7da0](https://github.com/viatcheslavmogilevsky/struktura23/commit/7da028f32c787b4f9e143ceeb4b116731dd71ad3) `new design: example of result query in quasi-API-requests`
	* quasi-API-request are more 'real' than quasi-SQL, but some jq stuff is still missing


## 18.09.2024

* [cc94](https://github.com/viatcheslavmogilevsky/struktura23/commit/cc94b89d584171960c569ba6afe98ea5ec2e1a28) `new design: example of result query in quasi-API-requests/validations/transformations`
	* pseudocode of how to query such spec

