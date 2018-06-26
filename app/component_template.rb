template 'app/javascript/components/commons/App.jsx.tt'
copy_file 'app/javascript/components/commons/DevView.jsx'
copy_file 'app/javascript/components/commons/index.js'

if apply_reactstrap?
    copy_file 'app/javascript/components/commons/Header.jsx'
    copy_file 'app/javascript/components/commons/Footer.jsx'
end
