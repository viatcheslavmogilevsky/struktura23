# Struktura23

## Features

No features yet :no_mouth:

## Roadmap 

1. Focused: TBD: opentofu module generator (JSON Configuration Syntax)
	* generating recursively :heavy_check_mark:
	* tests/fixtures :heavy_check_mark:
	* new design? :dart:
		* do not wrap into tf-module?
		* scheme???
	* optional nodes support: fix outputs (use 'one' function?)
	* plural nodes support: fix input (use object input type)
	* pulling schemas from providers (js/ts?) instead of mocking
	* expression resolving
	* "correlated" nodes along with wrapping
2. TBD: querying existing infra
3. TBD: generating `import` commands to instant import


## IRB driven development

```
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
load "#{File.dirname(__FILE__)}/examples/native-modules-rb/eks-with-nodes/modules-spec.rb"
```


## Daily progress


[Here!](deyliki.md)
 
