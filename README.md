# Strucktura23

## Features

### Roadmap 

1. Focused: TBD: opentofu module generator (JSON Configuration Syntax)
2. TBD: querying existing infra
3. TBD: generating `import` commands to instant import


## IRB driven development

```
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
load 'struktura23/base-spec.rb'
class ExampleTfModule < Struktura23::BaseSpec
# ...
end
```
 
