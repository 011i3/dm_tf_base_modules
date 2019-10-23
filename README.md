## TF MODULES VERSIONING 
We will be tagging our modules to differentiate which version to test before going on to production 

- E.g Nod prod env(dev|int|prf|) will have spcific version trsted before eventually running that version on production. 
- Using git tag to achieve this is the way 

## 
 git tag -a "v0.0.1" -m "First release of services web|app cluster"
 git push --follow-tags