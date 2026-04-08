# 个人网站编写指导文档

## 1. 开发环境准备

### 1.1 环境要求
```
Node.js: >= 18.x
包管理器: npm 或 pnpm
编辑器: VS Code（推荐）
```

### 1.2 推荐插件
```
- Vue - Official (Vue.volar)
- Vue VSCode Snippets
- ESLint
- Prettier
- CSS Peek
- Auto Rename Tag
```

---

## 2. 项目初始化

### 2.1 创建项目
```bash
# 使用 Vite 创建 Vue 项目
npm create vite@latest personal-site -- --template vue

# 进入项目目录
cd personal-site

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### 2.2 安装额外依赖
```bash
# 如果需要路由（单页应用可能不需要）
npm install vue-router

# 如果需要图标
npm install lucide-vue-next
```

---

## 3. 编码规范

### 3.1 命名规范

#### 文件命名
```
组件文件：PascalCase
  ✓ ModelCard.vue
  ✓ DrawingSection.vue
  ✗ modelCard.vue
  ✗ model-card.vue

样式文件：kebab-case
  ✓ modeling-section.css
  ✓ variables.css

数据文件：camelCase
  ✓ modelingData.js
  ✓ petImages.js
```

#### 组件命名
```vue
<!-- 推荐 -->
<script setup>
// 使用 PascalCase
import ModelCard from './ModelCard.vue'
</script>

<template>
  <ModelCard />
</template>
```

#### 变量命名
```javascript
// 常量：UPPER_SNAKE_CASE
const MAX_IMAGE_SIZE = 1920

// 变量/函数：camelCase
const imageList = []
const loadImages = () => {}

// 组件引用：camelCase + Ref 后缀
const navbarRef = ref(null)
const modelSectionRef = ref(null)
```

### 3.2 CSS 规范

#### 使用 CSS 变量
```css
/* variables.css */
:root {
  /* 建模区配色 */
  --modeling-bg: #0a0a0f;
  --modeling-border: #2a2a3a;
  --modeling-accent: #00d4ff;
  
  /* 温暖区配色 */
  --warm-bg: #f5f0e8;
  --warm-card: #ffffff;
  --warm-accent: #e8a87c;
  
  /* 间距 */
  --spacing-xs: 8px;
  --spacing-sm: 16px;
  --spacing-md: 24px;
  --spacing-lg: 32px;
  --spacing-xl: 48px;
}
```

#### Scoped CSS 组织
```vue
<style scoped>
/* 1. 布局相关 */
.section { }
.container { }
.grid { }

/* 2. 组件/元素 */
.card { }
.title { }
.description { }

/* 3. 状态 */
.card:hover { }
.card.active { }

/* 4. 动画 */
@keyframes fadeIn { }
</style>
```

### 3.3 Vue 组件规范

#### 组件结构顺序
```vue
<template>
  <!-- HTML 模板 -->
</template>

<script setup>
// 1. 导入
import { ref, computed, onMounted } from 'vue'
import ComponentA from './ComponentA.vue'

// 2. Props
const props = defineProps({
  title: String,
  items: Array
})

// 3. 响应式状态
const isLoading = ref(false)

// 4. 计算属性
const filteredItems = computed(() => {
  return props.items.filter(item => item.visible)
})

// 5. 方法
const handleClick = () => {}

// 6. 生命周期
onMounted(() => {})
</script>

<style scoped>
/* CSS 样式 */
</style>
```

#### Props 定义
```javascript
// 推荐：详细定义
defineProps({
  title: {
    type: String,
    required: true
  },
  items: {
    type: Array,
    default: () => []
  },
  size: {
    type: String,
    default: 'medium',
    validator: (value) => ['small', 'medium', 'large'].includes(value)
  }
})
```

---

## 4. 数据结构

### 4.1 建模作品数据
```javascript
// src/data/modeling.js
export const modelingWorks = [
  {
    id: 1,
    title: '角色名称',
    description: '简短描述',
    image: '/images/modeling/modeling-render-01-character.jpg',
    tags: ['Blender', 'ZBrush', 'Substance'],
    date: '2024-01'
  },
  // ... 更多作品
]
```

### 4.2 绘图作品数据
```javascript
// src/data/drawing.js
export const drawingWorks = [
  {
    id: 1,
    title: '作品名称',
    description: '简短描述',
    image: '/images/drawing/drawing-illustration-01-portrait.jpg',
    tags: ['Procreate', 'Digital Art'],
    date: '2024-01'
  },
  // ... 更多作品
]
```

### 4.3 宠物数据
```javascript
// src/data/pets.js
export const petsData = [
  {
    id: 1,
    name: '宠物名字',
    type: '猫', // 猫/狗/其他
    description: '关于这只宠物的故事',
    images: [
      '/images/pets/pets-photo-01-cat-sleeping.jpg',
      '/images/pets/pets-photo-02-cat-playing.jpg'
    ],
    birthDate: '2020-06'
  },
  // ... 更多宠物
]
```

---

## 5. 组件编写指南

### 5.1 导航栏组件
```vue
<!-- src/components/layout/Navbar.vue -->
<template>
  <nav class="navbar" :class="{ 'navbar--scrolled': isScrolled }">
    <div class="navbar__logo">
      <span>Your Name</span>
    </div>
    
    <ul class="navbar__menu">
      <li 
        v-for="item in menuItems" 
        :key="item.id"
        :class="{ 'navbar__item--active': activeSection === item.id }"
      >
        <a :href="'#' + item.id" @click.prevent="scrollTo(item.id)">
          {{ item.label }}
        </a>
      </li>
    </ul>
    
    <!-- 移动端汉堡菜单 -->
    <button class="navbar__toggle" @click="toggleMenu">
      <span></span>
      <span></span>
      <span></span>
    </button>
  </nav>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const menuItems = [
  { id: 'modeling', label: '建模区' },
  { id: 'drawing', label: '绘图区' },
  { id: 'pets', label: '宠物区' }
]

const isScrolled = ref(false)
const activeSection = ref('')
const isMenuOpen = ref(false)

const handleScroll = () => {
  isScrolled.value = window.scrollY > 50
  // 更新 activeSection 逻辑
}

const scrollTo = (id) => {
  // 平滑滚动逻辑
}

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>
```

### 5.2 作品卡片组件
```vue
<!-- src/components/cards/ModelCard.vue -->
<template>
  <article class="model-card">
    <div class="model-card__image-wrapper">
      <img 
        :src="image" 
        :alt="title"
        class="model-card__image"
        loading="lazy"
      />
    </div>
    <div class="model-card__content">
      <h3 class="model-card__title">{{ title }}</h3>
      <div class="model-card__tags">
        <span 
          v-for="tag in tags" 
          :key="tag" 
          class="model-card__tag"
        >
          {{ tag }}
        </span>
      </div>
    </div>
  </article>
</template>

<script setup>
defineProps({
  image: String,
  title: String,
  tags: Array
})
</script>

<style scoped>
.model-card {
  background: var(--modeling-bg);
  border: 1px solid var(--modeling-border);
  transition: all 0.3s ease;
}

.model-card:hover {
  border-color: var(--modeling-accent);
  box-shadow: 0 0 20px rgba(0, 212, 255, 0.2);
  transform: translateY(-4px);
}
</style>
```

### 5.3 区域组件
```vue
<!-- src/components/sections/ModelingSection.vue -->
<template>
  <section id="modeling" class="modeling-section">
    <div class="modeling-section__container">
      <header class="modeling-section__header">
        <h2 class="modeling-section__title">建模作品</h2>
        <p class="modeling-section__subtitle">
          三维世界的冷峻美学
        </p>
      </header>
      
      <div class="modeling-section__grid">
        <ModelCard 
          v-for="work in modelingWorks" 
          :key="work.id"
          :image="work.image"
          :title="work.title"
          :tags="work.tags"
        />
      </div>
    </div>
  </section>
</template>

<script setup>
import { modelingWorks } from '@/data/modeling.js'
import ModelCard from '@/components/cards/ModelCard.vue'
</script>

<style scoped>
@import '@/styles/modeling.css';

.modeling-section {
  background: var(--modeling-bg);
  padding: var(--spacing-xxxl) var(--spacing-lg);
}

.modeling-section__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: var(--spacing-lg);
}
</style>
```

---

## 6. 样式编写指南

### 6.1 全局样式结构
```
styles/
├── variables.css    # CSS 变量（颜色、间距、字体）
├── base.css         # 重置样式、基础排版
├── modeling.css     # 建模区专属样式
├── warm.css         # 温暖风格样式（绘图区、宠物区）
└── animations.css   # 动画关键帧
```

### 6.2 建模区样式示例
```css
/* modeling.css */

/* 建模区背景网格 */
.modeling-bg {
  background-color: var(--modeling-bg);
  background-image: 
    linear-gradient(rgba(0, 212, 255, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 212, 255, 0.03) 1px, transparent 1px);
  background-size: 50px 50px;
}

/* 发光边框效果 */
.modeling-border {
  border: 1px solid var(--modeling-border);
  box-shadow: 
    inset 0 0 20px rgba(0, 212, 255, 0.05),
    0 0 20px rgba(0, 212, 255, 0.1);
}

/* 标题样式 */
.modeling-title {
  font-family: 'Orbitron', monospace;
  color: var(--modeling-accent);
  text-shadow: 0 0 10px rgba(0, 212, 255, 0.5);
  letter-spacing: 0.1em;
}
```

### 6.3 温暖风格样式示例
```css
/* warm.css */

/* 温暖背景 */
.warm-bg {
  background: linear-gradient(
    180deg,
    var(--warm-bg) 0%,
    #ebe5db 100%
  );
}

/* 温暖卡片 */
.warm-card {
  background: var(--warm-card);
  border-radius: 12px;
  box-shadow: 
    0 4px 6px rgba(93, 78, 60, 0.07),
    0 10px 20px rgba(93, 78, 60, 0.05);
  transition: all 0.3s ease;
}

.warm-card:hover {
  transform: translateY(-8px);
  box-shadow: 
    0 8px 12px rgba(93, 78, 60, 0.1),
    0 20px 40px rgba(93, 78, 60, 0.08);
}

/* 标题样式 */
.warm-title {
  font-family: 'Playfair Display', serif;
  color: var(--warm-text);
}
```

---

## 7. 图片处理指南

### 7.1 图片优化
```bash
# 推荐尺寸
- 缩略图：400px 宽度
- 展示图：800px - 1200px 宽度
- 格式：WebP 优先，JPEG/PNG 备选

# 压缩工具
- TinyPNG / Squoosh
- 命令行：imagemagick, sharp
```

### 7.2 图片懒加载
```vue
<template>
  <img 
    :src="placeholderSrc"
    :data-src="realSrc"
    loading="lazy"
    @load="onImageLoad"
  />
</template>

<script setup>
// 使用 Intersection Observer
import { ref, onMounted } from 'vue'

const realSrc = '/images/large-image.jpg'
const placeholderSrc = '/images/placeholder.jpg'
const isLoaded = ref(false)

const onImageLoad = () => {
  isLoaded.value = true
}
</script>
```

### 7.3 图片占位符
```vue
<template>
  <div class="image-wrapper">
    <!-- 骨架屏 -->
    <div v-if="!isLoaded" class="skeleton"></div>
    
    <img 
      :src="src"
      :alt="alt"
      loading="lazy"
      @load="isLoaded = true"
      :class="{ 'image--loaded': isLoaded }"
    />
  </div>
</template>

<style scoped>
.skeleton {
  background: linear-gradient(
    90deg,
    #f0f0f0 25%,
    #e0e0e0 50%,
    #f0f0f0 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
</style>
```

---

## 8. 响应式开发

### 8.1 媒体查询断点
```css
/* 移动优先 */

/* 平板 */
@media (min-width: 768px) {
  .grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* 桌面 */
@media (min-width: 1024px) {
  .grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

/* 大屏 */
@media (min-width: 1440px) {
  .container {
    max-width: 1400px;
  }
}
```

### 8.2 移动端导航
```vue
<template>
  <nav class="navbar">
    <!-- 桌面菜单 -->
    <ul class="navbar__menu navbar__menu--desktop">
      <!-- ... -->
    </ul>
    
    <!-- 移动端汉堡按钮 -->
    <button 
      class="navbar__toggle navbar__toggle--mobile"
      @click="toggleMenu"
    >
      <span></span>
      <span></span>
      <span></span>
    </button>
    
    <!-- 移动端菜单 -->
    <div 
      class="navbar__mobile-menu"
      :class="{ 'navbar__mobile-menu--open': isMenuOpen }"
    >
      <!-- ... -->
    </div>
  </nav>
</template>

<style scoped>
.navbar__menu--desktop {
  display: flex;
}

.navbar__toggle--mobile {
  display: none;
}

@media (max-width: 767px) {
  .navbar__menu--desktop {
    display: none;
  }
  
  .navbar__toggle--mobile {
    display: block;
  }
}
</style>
```

---

## 9. 测试清单

### 9.1 功能测试
```
□ 导航点击滚动正常
□ 当前区域高亮正确
□ 图片加载正常
□ 移动端菜单正常
□ 卡片悬停效果正常
```

### 9.2 响应式测试
```
□ 320px - 375px（小屏手机）
□ 375px - 768px（手机）
□ 768px - 1024px（平板）
□ 1024px - 1440px（桌面）
□ > 1440px（大屏）
```

### 9.3 浏览器测试
```
□ Chrome
□ Firefox
□ Safari
□ Edge
```

### 9.4 性能测试
```
□ 图片懒加载正常
□ 首屏加载时间 < 3s
□ 无布局抖动 (CLS)
□ 滚动流畅 (60fps)
```

---

## 10. 部署建议

### 10.1 构建优化
```javascript
// vite.config.js
export default defineConfig({
  build: {
    // 代码分割
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['vue'],
          utils: ['lodash-es']
        }
      }
    },
    // 图片压缩
    assetsInlineLimit: 4096
  }
})
```

### 10.2 部署平台
```
推荐平台：
- Vercel
- Netlify
- GitHub Pages
- Cloudflare Pages
```

### 10.3 构建命令
```bash
# 构建
npm run build

# 预览构建结果
npm run preview

# 部署到 Vercel
vercel --prod
```