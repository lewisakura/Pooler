"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[374],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>d});var r=n(67294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function c(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var i=r.createContext({}),s=function(e){var t=r.useContext(i),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(i.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},m=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,i=e.parentName,u=c(e,["components","mdxType","originalType","parentName"]),m=s(n),d=a,h=m["".concat(i,".").concat(d)]||m[d]||p[d]||o;return n?r.createElement(h,l(l({ref:t},u),{},{components:n})):r.createElement(h,l({ref:t},u))}));function d(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,l=new Array(o);l[0]=m;var c={};for(var i in t)hasOwnProperty.call(t,i)&&(c[i]=t[i]);c.originalType=e,c.mdxType="string"==typeof e?e:a,l[1]=c;for(var s=2;s<o;s++)l[s]=n[s];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}m.displayName="MDXCreateElement"},4167:(e,t,n)=>{n.r(t),n.d(t,{HomepageFeatures:()=>b,default:()=>w});var r=n(87462),a=n(67294),o=n(3905);const l={toc:[{value:"Why use an instance pooler?",id:"why-use-an-instance-pooler",level:2},{value:"Why use Pooler?",id:"why-use-pooler",level:2},{value:"Getting Started",id:"getting-started",level:2}]};function c(e){let{components:t,...n}=e;return(0,o.kt)("wrapper",(0,r.Z)({},l,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h2",{id:"why-use-an-instance-pooler"},"Why use an instance pooler?"),(0,o.kt)("p",null,"Take the scenario of a bullet hell game. Think ",(0,o.kt)("a",{parentName:"p",href:"https://en.wikipedia.org/wiki/Touhou_Project"},"Touhou"),". These games generally have a lot of objects:"),(0,o.kt)("p",null,(0,o.kt)("img",{parentName:"p",src:"https://pbs.twimg.com/media/Dd57rC3UwAIHktD.jpg",alt:"bullets!!!"})),(0,o.kt)("p",null,"It's more performant to recycle these objects than destroy and recreate them. Whilst the differences are small, when the time it takes adds up,\nyour game will be a lot slower by removing and creating instances when compared to using an instance pooler."),(0,o.kt)("h2",{id:"why-use-pooler"},"Why use Pooler?"),(0,o.kt)("p",null,"Pooler is designed to take any instance type and pool it. The majority of poolers I've seen can only accept parts and the ones I've seen that don't\ndo not have much customizability. I wrote Pooler to fill that gap for myself, and now I'm releasing it here."),(0,o.kt)("p",null,"Needless to say, Pooler is not perfect. There are many improvements that can be made, especially related to returning objects to the pool and what to\ndo on exhaustion. For the majority of tasks, however, Pooler is a suitable library that will handle thousands of objects easily."),(0,o.kt)("h2",{id:"getting-started"},"Getting Started"),(0,o.kt)("p",null,"Create your Pooler:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local template = Instance.new("Part")\n\ntemplate.Anchored = true\n\ntemplate.Material = Enum.Material.Neon\ntemplate.BrickColor = BrickColor.Green()\n\nlocal pool = Pooler.new(template)\n')),(0,o.kt)("p",null,"Now, you can fetch instances from it:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"local instance = pool:Get()\n")),(0,o.kt)("p",null,"Once you're done with that instance, just (optionally) return it to the pool again:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"pool:Return(instance)\n")))}c.isMDXComponent=!0;var i=n(39960),s=n(52263),u=n(4194),p=n(86010);const m="heroBanner_e1Bh",d="buttons_VwD3",h="features_WS6B",y="featureSvg_tqLR",f=[{title:"Speedy",description:"Faster than the equivalent Instance.new() calls by ~42% in the best case scenario."},{title:"Easy",description:"Easy to use and drop in to your existing codebase. No need to make massive alterations."},{title:"Customizable",description:"All the options under the sun, and then some."}];function g(e){let{image:t,title:n,description:r}=e;return a.createElement("div",{className:(0,p.Z)("col col--4")},t&&a.createElement("div",{className:"text--center"},a.createElement("img",{className:y,alt:n,src:t})),a.createElement("div",{className:"text--center padding-horiz--md"},a.createElement("h3",null,n),a.createElement("p",null,r)))}function b(){return f?a.createElement("section",{className:h},a.createElement("div",{className:"container"},a.createElement("div",{className:"row"},f.map(((e,t)=>a.createElement(g,(0,r.Z)({key:t},e))))))):null}function v(){const{siteConfig:e}=(0,s.Z)();return a.createElement("header",{className:(0,p.Z)("hero",m)},a.createElement("div",{className:"container"},a.createElement("h1",{className:"hero__title"},e.title),a.createElement("p",{className:"hero__subtitle"},e.tagline),a.createElement("div",{className:d},a.createElement(i.Z,{className:"button button--secondary button--lg",to:"/docs/intro"},"Get Started \u2192"))))}function w(){const{siteConfig:e,tagline:t}=(0,s.Z)();return a.createElement(u.Z,{title:e.title,description:t},a.createElement(v,null),a.createElement("main",null,a.createElement(b,null),a.createElement("div",{className:"container"},a.createElement(c,null))))}}}]);