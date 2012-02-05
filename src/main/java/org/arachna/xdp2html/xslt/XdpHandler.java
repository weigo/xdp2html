/*
 * Copyright 2005, 2007 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.arachna.xdp2html.xslt;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.Map;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.log4j.Logger;

/**
 * Handler for XDP documents. Converts XDP documents to HTML.
 * 
 * @author weigo
 */
public class XdpHandler {
    /**
     * Logger.
     */
    private static final Logger log = Logger.getLogger(XdpHandler.class);

    /**
     * Stylesheet for removal of namespaces from the XDP document.
     */
    private static final String REMOVE_NAME_SPACES = "removenamespaces.xsl";

    /**
     * stylesheet for conversion to HTML.
     */
    private static final String XDP_2_HTML = "xdp2html.xsl";

    /**
     * Transform a XDP document to HTML.
     * 
     * @param document
     *            InputStream containing the XDP document to transform.
     * @param params
     *            parameters that should be used in the stylesheet
     * @return a byte array containing the converted document
     */
    public byte[] handle(final InputStream document, final Map<String, String> params) {
        byte result[] = new byte[0];

        final TransformerFactory transformerFactory = TransformerFactory.newInstance();

        try {
            // remove namespaces
            final Source removeNameSpaceSource =
                new StreamSource(this.getClass().getResourceAsStream(REMOVE_NAME_SPACES));
            final Transformer removeNameSpaceTransformer = transformerFactory.newTransformer(removeNameSpaceSource);
            final Source documentSource = new StreamSource(document);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            final StreamResult removeNameSpaceResult = new StreamResult(baos);

            removeNameSpaceTransformer.transform(documentSource, removeNameSpaceResult);
            final ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());

            // convert resulting document to HTML
            final Source xdp2HtmlSource = new StreamSource(this.getClass().getResourceAsStream(XDP_2_HTML));
            final Transformer xdp2HtmlTransformer = transformerFactory.newTransformer(xdp2HtmlSource);
            final Source documentSourceWithNameSpaceRemoved = new StreamSource(bais);
            baos = new ByteArrayOutputStream();
            final StreamResult xdp2HtmlResult = new StreamResult(baos);

            // set parameters for stylesheet
            for (final Map.Entry<String, String> entry : params.entrySet()) {
                xdp2HtmlTransformer.setParameter(entry.getKey(), entry.getValue());
            }

            xdp2HtmlTransformer.transform(documentSourceWithNameSpaceRemoved, xdp2HtmlResult);
            result = baos.toByteArray();
        }
        catch (final TransformerConfigurationException tce) {
            log.error(tce.getMessage(), tce);
        }
        catch (final TransformerException te) {
            log.error(te.getMessage(), te);
        }

        return result;
    }
}
