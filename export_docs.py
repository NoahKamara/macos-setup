

with open("install.sh") as fp:
    lines = fp.readlines()

with open("scripts/defaults.sh") as fp:
    lines += fp.readlines()

doc_lines = []
for line in lines[7:]:
    line = line.strip()
    if (not line.startswith("#") and (not line.startswith("###"))):
        continue

    text = line.replace("#","").strip()
    if text == "":
        continue
    if line.startswith("##"):
        doc_lines.append("")
        doc_lines.append("### "+text)
    else:
        doc_lines.append(" - "+text)

with open("docs.md", "w") as fp:
    fp.write("\n".join(doc_lines))
        
