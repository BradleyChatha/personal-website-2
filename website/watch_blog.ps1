cd .\tools\blog_gen
dub build
cd ../../

while ($true) { tools/blog_gen/blog_gen.exe watch assets/blog content/blog }