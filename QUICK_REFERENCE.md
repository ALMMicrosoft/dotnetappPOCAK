# 🚀 GitHub Actions Quick Reference

## One-Line Commands

### Push to GitHub
```bash
git init && git add . && git commit -m "Add CI/CD pipeline" && git remote add origin YOUR_REPO_URL && git push -u origin main
```

### Manual Workflow Trigger
GitHub → Actions → Build .NET Framework Calculator → Run workflow

### Download Artifacts
GitHub → Actions → [Workflow Run] → Artifacts → Download

## 📋 Workflow Overview

| Event | Branches | Action |
|-------|----------|--------|
| Push | main, master, develop | Build + Artifacts + Release ZIPs |
| Pull Request | main, master, develop | Build + Artifacts |
| Manual | Any | Build + Artifacts |

## 📦 Artifacts

| Name | Contents | Retention |
|------|----------|-----------|
| Calculator-WindowsForms | Desktop .exe + config | 30 days |
| Calculator-Web | Web .exe + wwwroot + deps | 30 days |
| Calculator-Release-Packages | Timestamped ZIPs | 90 days |

## 🔧 Build Process

```
Checkout → Setup → Restore → Build WinForms → Build Web → Copy wwwroot → Test → Upload
```

## 📝 Key Files

- `.github/workflows/build.yml` - Main workflow
- `GITHUB_ACTIONS_GUIDE.md` - Full documentation
- `SETUP_SUMMARY.md` - Setup overview
- `.github/CONTRIBUTING.md` - How to contribute
- `.gitignore` - Ignore rules

## ✅ Checklist

- [ ] Create GitHub repository
- [ ] Push code to GitHub
- [ ] Verify workflow runs successfully
- [ ] Download and test artifacts
- [ ] Update README badge with your repo URL
- [ ] Share with team!

## 🆘 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails | Check Actions logs for errors |
| No artifacts | Verify build succeeded |
| wwwroot missing | Check "Copy wwwroot files" step |
| NuGet restore fails | Check internet/packages |

## 🎯 Success Indicators

✅ Green check mark in Actions tab  
✅ Artifacts available for download  
✅ Build badge shows "passing"  
✅ ZIP files generated (main/master only)

---

**Need Help?** Check `GITHUB_ACTIONS_GUIDE.md` for detailed documentation
