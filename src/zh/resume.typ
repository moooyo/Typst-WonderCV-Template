#import "../common/template.typ": resume-template

// 读取分离的JSON数据文件
#let basic-data = json("../data/zh/basic.json")
#let education-data = json("../data/zh/education.json")
#let experience-data = json("../data/zh/experience.json")
#let projects-data = json("../data/zh/projects.json")

// 渲染中文简历
#resume-template(
  name: basic-data.name,
  contact: basic-data.contact,
  education: education-data,
  experience: experience-data,
  projects: projects-data,
  is-chinese: true,
  lang-config: basic-data.lang_config
)