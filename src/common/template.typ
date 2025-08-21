// =============================================================================
// 现代化简历模板
// =============================================================================
// 使用 Typst 现代语法和最佳实践
// 配置集中在 settings.typ 中管理，所有样式参数均从配置文件中读取

#import "settings.typ": settings

// 主模板函数 - 使用现代化 Typst 语法
#let resume-template(
  name: "",
  contact: (:),
  education: (),
  experience: (),
  projects: (),
  is-chinese: false,
  lang-config: (:)
) = {
  // 现代化页面设置 - 使用命名参数
  set page(
    margin: (
      x: settings.page.margin-x, 
      y: settings.page.margin-y
    )
  )
  set par(justify: settings.paragraph.justify)
  
  // 根据语言选择字体配置 - 简化条件逻辑
  let font-family = if is-chinese { settings.fonts.chinese } else { settings.fonts.english }
  set text(
    font: font-family,
    size: settings.font-sizes.base
  )
  
  // 现代化分割线函数 - 使用更清晰的语法
  let chiline = {
    v(settings.spacing.line-top)
    line(stroke: (
      paint: settings.colors.cv-color, 
      thickness: settings.lines.stroke-width
    ), length: settings.lines.length)
    v(settings.spacing.line-bottom)
  }
  
  // 现代化 show 规则 - 使用更精确的选择器
  show "|": text(settings.colors.gray, settings.contact.separator)
  show heading.where(level: 1): it => {
    text(
      fill: settings.colors.text-dark, 
      size: settings.font-sizes.name, 
      weight: "black"
    )[#it.body]
    v(settings.spacing.heading-bottom)
  }
  show heading.where(level: 2): it => {
    text(
      fill: settings.colors.text-dark, 
      size: settings.font-sizes.section-heading,
      weight: "semibold"
    )[#it.body]
    chiline
  }
  
  // 个人信息头部 - 使用现代化的网格布局
  grid(
    columns: settings.layout.grid-columns.two-column,
    align(center)[
      = #name

      #set text(settings.colors.text-medium)
      
      #let contact-items = ()
      #if "phone" in contact { contact-items.push(contact.phone) }
      #if "email" in contact { contact-items.push(contact.email) }
      #if "wechat" in contact {
        let wechat-prefix = if is-chinese {
          settings.contact.wechat-label.chinese
        } else {
          settings.contact.wechat-label.english
        }
        contact-items.push(wechat-prefix + contact.wechat)
      }
      
      #if contact-items.len() > 0 {
        contact-items.join(settings.contact.separator.trim())
      }
    ], 
    // 照片占位符（保留扩展性）
    []
  )

  set text(settings.colors.text-light)

  // 工作经历 - 使用现代化的布局和样式
  if experience.len() > 0 {
    [== #lang-config.at("experience", default: "Experience")]
    
    for exp in experience {
      // 第一行：公司名称（左对齐）和日期（右对齐）
      grid(
        columns: settings.layout.grid-columns.two-column,
        align: (left, right),
        text(
          fill: settings.colors.text-medium, 
          weight: "bold", 
          size: settings.font-sizes.sub-heading
        )[#exp.at("company", default: "")],
        text(
          fill: settings.colors.gray, 
          weight: "regular", 
          size: settings.font-sizes.sub-heading
        )[#exp.at("duration", default: "")],
      )
      v(settings.spacing.grid-row-spacing)  // 使用统一的grid行间距配置
      
      // 第二行：职位（左对齐）和地点（右对齐）
      let pos = exp.at("position", default: "")
      let loc = exp.at("location", default: "")
      
      if pos != "" or loc != "" {
        grid(
          columns: settings.layout.grid-columns.two-column,
          align: (left, right),
          text(
            fill: settings.colors.text-dark,
            style: "italic", 
            size: settings.font-sizes.description
          )[#pos],
          text(
            fill: settings.colors.gray,
            size: settings.font-sizes.description
          )[#loc],
        )
        v(settings.spacing.grid-row-spacing)  // 使用统一的grid行间距配置
      }
      
      let desc = exp.at("description", default: ())
      for d in desc {
        text(
          fill: settings.colors.text-light,
          size: settings.font-sizes.description
        )[#settings.list.bullet #d]
        linebreak()
      }
      v(settings.spacing.section-item-spacing)
    }
  }

  // 项目经历 - 使用现代化的布局和样式
  if projects.len() > 0 {
    [== #lang-config.at("projects", default: "Projects")]
    
    for proj in projects {
      // 第一行：项目名称（左对齐）和日期（右对齐）
      grid(
        columns: settings.layout.grid-columns.two-column,
        align: (left, right),
        text(
          fill: settings.colors.text-dark, 
          weight: "bold", 
          size: settings.font-sizes.sub-heading
        )[#proj.at("name", default: "")],
        text(
          fill: settings.colors.gray, 
          weight: "regular", 
          size: settings.font-sizes.sub-heading
        )[#proj.at("duration", default: "")],
      )
      v(settings.spacing.grid-row-spacing)  // 使用统一的grid行间距配置
      
      let desc = proj.at("description", default: ())
      if desc != () {
        if type(desc) == array {
          // 处理数组格式的描述
          for paragraph in desc {
            let content = if is-chinese {
              // 中文段落添加两格缩进
              "　　" + paragraph
            } else {
              // 英文段落不添加缩进
              paragraph
            }
            text(
              fill: settings.colors.text-light,
              size: settings.font-sizes.description
            )[#content]
            linebreak()
          }
        } else {
          // 兼容旧的字符串格式
          let content = if is-chinese {
            "　　" + desc
          } else {
            desc
          }
          text(
            fill: settings.colors.text-light,
            style: "italic", 
            size: settings.font-sizes.description
          )[#content]
          linebreak()
        }
      }
      
      let details = proj.at("details", default: ())
      for detail in details {
        text(
          fill: settings.colors.text-light,
          size: settings.font-sizes.description
        )[#settings.list.bullet #detail]
        linebreak()
      }
      v(settings.spacing.section-item-spacing)
    }
  }

  // 教育经历 - 使用现代化的布局和样式
  if education.len() > 0 {
    [== #lang-config.at("education", default: "Education")]
    
    for edu in education {
      // 第一行：学校名称（左对齐）和日期（右对齐）
      grid(
        columns: settings.layout.grid-columns.two-column,
        align: (left, right),
        text(
          fill: settings.colors.text-medium, 
          weight: "bold", 
          size: settings.font-sizes.sub-heading
        )[#edu.at("institution", default: "")],
        text(
          fill: settings.colors.gray, 
          weight: "regular", 
          size: settings.font-sizes.sub-heading
        )[#edu.at("duration", default: "")],
      )
      
      // 第二行：学位（左对齐）和地点（右对齐）
      let degree = edu.at("degree", default: "")
      let loc = edu.at("location", default: "")
      
      if degree != "" or loc != "" {
        grid(
          columns: settings.layout.grid-columns.two-column,
          align: (left, right),
          text(
            fill: settings.colors.text-dark,
            style: "italic", 
            size: settings.font-sizes.description
          )[#degree],
          text(
            fill: settings.colors.gray,
            size: settings.font-sizes.description
          )[#loc],
        )
      }
      
      let details = edu.at("details", default: ())
      for detail in details {
        text(
          fill: settings.colors.text-light,
          size: settings.font-sizes.description
        )[#settings.list.bullet #detail]
        linebreak()
      }
      v(settings.spacing.section-item-spacing)
    }
  }
}
