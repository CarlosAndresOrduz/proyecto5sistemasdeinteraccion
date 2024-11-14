# Miniproyecto 5 - Sistemas de Interacción

## Descripción

En este proyecto se creó un sonificador de datos que permite visualizar y producir sonidos a partir de un conjunto de datos. Utilizando las herramientas **Processing** y **Pure Data**, se toma un dataset relacionado con diferentes diagnósticos psicológicos y sus respectivas escalas musicales. A medida que los datos se visualizan, se activa una sonificación que refleja la información de manera interactiva. La experiencia busca integrar lo visual y lo auditivo, permitiendo que el usuario interactúe con los datos a través de ambas dimensiones.

## Requerimientos del Proyecto

1. **Uso de Processing y Pure Data**:
   - **Processing** se utiliza para la visualización de los datos.
   - **Pure Data** es el encargado de generar los sonidos según las interacciones y el análisis de los datos.

2. **Sonificación y Visualización Interactivas**:
   - Los datos se visualizan de forma dinámica.
   - La sonificación refleja de manera coherente la información de los datos.
   - La interacción entre lo visual y lo auditivo permite que los cambios en los datos modifiquen tanto el aspecto visual como el auditivo.

3. **Uso de Dataset Público**:
   - Se utiliza un conjunto de datos relacionado con diagnósticos psicológicos, con valores asociados a diferentes estados emocionales y sus correspondientes escalas musicales.
   - Los cambios en el dataset afectan tanto la visualización como la sonificación.

4. **Interactividad entre lo Visual y lo Auditivo**:
   - Los usuarios pueden interactuar con la visualización, lo que genera cambios en la sonificación.
   - Los cambios gráficos en Processing afectan el sonido en Pure Data.

## Diagnósticos y Escalas Musicales

A continuación, se presentan los diagnósticos psicológicos y las correspondientes escalas musicales que se usan para la sonificación:

### 1. Diagnóstico: Major Depressive Disorder (Escala de Re mayor - D)
- **Anxious → Re (D): 62**
- **Neutral → Mi (E): 64**
- **Happy → Fa# (F#): 66**
- **Excited → Sol (G): 67**
- **Stressed → La (A): 69**
- **Depressed → Si (B): 71**

### 2. Diagnóstico: Panic Disorder (Escala de Mi mayor - E)
- **Anxious → Mi (E): 64**
- **Neutral → Fa# (F#): 66**
- **Happy → Sol# (G#): 68**
- **Excited → La (A): 69**
- **Stressed → Si (B): 71**
- **Depressed → Do# (C#): 73**

### 3. Diagnóstico: Generalized Anxiety (Escala de Fa mayor - F)
- **Anxious → Fa (F): 65**
- **Neutral → Sol (G): 67**
- **Happy → La (A): 69**
- **Excited → Si♭ (B♭): 70**
- **Stressed → Do (C): 72**
- **Depressed → Re (D): 74**

### 4. Diagnóstico: Bipolar Disorder (Escala de Sol mayor - G)
- **Anxious → Sol (G): 67**
- **Neutral → La (A): 69**
- **Happy → Si (B): 71**
- **Excited → Do (C): 72**
- **Stressed → Re (D): 74**
- **Depressed → Mi (E): 76**

## Archivos del Proyecto

El proyecto está compuesto por los siguientes archivos:

- **CSV con la base de datos**: Contiene los datos de los diagnósticos y las notas correspondientes a las escalas musicales.
- **Código en Pure Data**: Configuración y programación de los sonidos y la interacción.
- **Código en Processing**: Visualización y control de la interfaz.

## Paso a Paso para Usar el Proyecto

1. **Clonar el repositorio**:
   - Clona el repositorio desde GitHub utilizando el siguiente comando:
     ```
     git clone <URL del repositorio>
     ```

2. **Requisitos previos**:
   - Asegúrate de tener instalados **Processing** y **Pure Data** en tu computadora.
   - Descarga el archivo CSV con los datos y ubícalo en la carpeta del proyecto.

3. **Modificar la dirección IP**:
   - En el código de **Processing**, se debe ajustar la dirección IP de acuerdo a la red del usuario. Esto se realiza modificando las líneas 83, 98 y 129, donde se establece la dirección IP para enviar los mensajes OSC a **Pure Data**.

     Ejemplo de cómo modificar la IP:
     ```java
     OscMessage mensajeOSC = new OscMessage("/notaCorrecta");
     mensajeOSC.add(c.Nota); // Enviar la nota como un parámetro
     oscP5.send(mensajeOSC, new NetAddress("192.168.115.25", 11111)); // Puerto de PD (ajustar si es necesario)
     ```
   - Asegúrate de que la dirección IP corresponde a la red en la que se encuentra el dispositivo ejecutando **Pure Data**.

4. **Ejecutar el Proyecto**:
   - Ejecuta el código en **Processing** y **Pure Data**.
   - Interactúa con la visualización y observa cómo los cambios en los datos modifican la sonificación.

## Conclusión

Este proyecto demuestra cómo es posible combinar la visualización y la sonificación de datos de manera interactiva, utilizando **Processing** para la visualización y **Pure Data** para la sonificación. A través de este enfoque, se explora cómo las emociones y diagnósticos psicológicos pueden ser representados tanto visual como auditivamente, brindando una experiencia multisensorial que permite una mejor comprensión y análisis de los datos.

---
