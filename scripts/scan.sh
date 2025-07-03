#!/bin/sh

echo "🔍 Ejecutando Checkov..."
checkov --directory /terraform \
        -o junitxml \
        --output-file-path results.xml \
        --quiet \
        --compact

echo "✅ Escaneo completado - Revisa results.xml para ver los resultados"