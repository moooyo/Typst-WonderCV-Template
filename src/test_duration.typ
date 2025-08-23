#import "common/template.typ": resume-template

// 测试不同duration格式的数据
#let test-data = json("data/test_duration_format.json")
#let basic-data = json("data/zh/basic.json")

// 渲染测试简历
#resume-template(
  name: "测试 Duration 格式",
  contact: basic-data.contact,
  education: (),
  experience: test-data,
  projects: (),
  is-chinese: true,
  lang-config: basic-data.lang_config
)
