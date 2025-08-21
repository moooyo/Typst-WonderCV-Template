#import "../common/template.typ": resume-template

// Read separated JSON data files
#let basic-data = json("../data/en/basic.json")
#let education-data = json("../data/en/education.json")
#let experience-data = json("../data/en/experience.json")
#let projects-data = json("../data/en/projects.json")

// Render English resume
#resume-template(
  name: basic-data.name,
  contact: basic-data.contact,
  education: education-data,
  experience: experience-data,
  projects: projects-data,
  is-chinese: false,
  lang-config: basic-data.lang_config
)