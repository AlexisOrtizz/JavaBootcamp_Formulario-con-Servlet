function abrirFormulario() {
    opcion = document.getElementById("select1")

    if(opcion.value === 'consultar') {
        /* --- */
    } else if(opcion.value === 'clientes') {
        window.open('frmCliente.html', "_self")
    } else if(opcion.value === 'monedas') {
        window.open('frmMoneda.html', "_self")
    } else if(opcion.value === 'productos') {
        /* llamada a Servlet: window.open('./listaClientes', "_self") */
        window.open('./frmProducto', "_self")
    }
}