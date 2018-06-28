template 'app/javascript/components/commons/App.jsx.tt'
copy_file 'app/javascript/components/commons/DevView.jsx'
copy_file 'app/javascript/components/commons/index.js'

case apply_ui_template?
when 'B'
    copy_file 'app/javascript/components/commons/bootstrap/Header.jsx', 'app/javascript/components/commons/Header.jsx'
    copy_file 'app/javascript/components/commons/bootstrap/Footer.jsx', 'app/javascript/components/commons/Footer.jsx'
when 'M'
    copy_file 'app/javascript/components/commons/material/Header.jsx', 'app/javascript/components/commons/Header.jsx'
    copy_file 'app/javascript/components/commons/material/Footer.jsx', 'app/javascript/components/commons/Footer.jsx'
else
end
